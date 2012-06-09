require 'cgi'
require 'sinatra'
require  Rails.root + 'lib/gollum/lib/gollum'
require 'mustache/sinatra'

require Rails.root + 'lib/gollum/lib/gollum/frontend/views/layout'
require Rails.root + 'lib/gollum/lib/gollum/frontend/views/editable'

module Precious
  class App < Sinatra::Base
    register Mustache::Sinatra

    dir = File.dirname(File.expand_path(__FILE__))

    # We want to serve public assets for now
    set :public_folder, "#{dir}/public/gollum"
    set :static,         true
    set :default_markup, :markdown
    set :run, false
    set :mount_point, WikiMounter.mount_point


    set :mustache, {
      # Tell mustache where the Views constant lives
      :namespace => Precious,

      # Mustache templates live here
      :templates => "#{dir}/templates",

      # Tell mustache where the views are
      :views => "#{dir}/views"
    }

    # Sinatra error handling
    configure :development, :staging do
      enable :show_exceptions, :dump_errors
      disable :raise_errors, :clean_trace
    end

    configure :test do
      enable :logging, :raise_errors, :dump_errors
    end

    get settings.mount_point do
      show_page_or_file('Home')
    end

    get "#{settings.mount_point}/edit/*" do
      @name = params[:splat].first
      @mount_point = settings.mount_point
      wiki = Gollum::Wiki.new(settings.gollum_path, settings.wiki_options)
      if page = wiki.page(@name)
        @page = page
        @content = page.raw_data
        mustache :edit
      else
        mustache :create
      end
    end

    post "#{settings.mount_point}/edit/*" do
      @mount_point = settings.mount_point
      wiki = Gollum::Wiki.new(settings.gollum_path, settings.wiki_options)
      page = wiki.page(params[:splat].first)
      name = params[:rename] || page.name
      committer = Gollum::Committer.new(wiki, commit_message)
      commit    = {:committer => committer}

      update_wiki_page(wiki, page, params[:content], commit, name,
        params[:format])
      update_wiki_page(wiki, page.footer,  params[:footer],  commit) if params[:footer]
      update_wiki_page(wiki, page.sidebar, params[:sidebar], commit) if params[:sidebar]
      committer.commit

      redirect "#{settings.mount_point}/#{CGI.escape(Gollum::Page.cname(name))}"
    end

    post "#{settings.mount_point}/create" do
      @mount_point = settings.mount_point
      name = params[:page]
      wiki = Gollum::Wiki.new(settings.gollum_path, settings.wiki_options)

      format = params[:format].intern

      begin
        wiki.write_page(name, format, params[:content], commit_message)
        redirect "#{settings.mount_point}/#{CGI.escape(Gollum::Page.cname(name))}"
      rescue Gollum::DuplicatePageError => e
        @message = "Duplicate page: #{e.message}"
        mustache :error
      end
    end

    post "#{settings.mount_point}/revert/:page/*" do
      @mount_point = settings.mount_point
      wiki  = Gollum::Wiki.new(settings.gollum_path, settings.wiki_options)
      @name = params[:page]
      @page = wiki.page(@name)
      shas  = params[:splat].first.split("/")
      sha1  = shas.shift
      sha2  = shas.shift

      if wiki.revert_page(@page, sha1, sha2, commit_message)
        redirect "#{settings.mount_point}/#{CGI.escape(@name)}"
      else
        sha2, sha1 = sha1, "#{sha1}^" if !sha2
        @versions = [sha1, sha2]
        diffs     = wiki.repo.diff(@versions.first, @versions.last, @page.path)
        @diff     = diffs.first
        @message  = "The patch does not apply."
        mustache :compare
      end
    end

    post "#{settings.mount_point}/preview" do
      @mount_point = settings.mount_point
      wiki      = Gollum::Wiki.new(settings.gollum_path, settings.wiki_options)
      @name     = "Preview"
      @page     = wiki.preview_page(@name, params[:content], params[:format])
      @content  = @page.formatted_data
      @editable = false
      mustache :page
    end

    get "#{settings.mount_point}/history/:name" do
      @mount_point = settings.mount_point
      @name     = params[:name]
      wiki      = Gollum::Wiki.new(settings.gollum_path, settings.wiki_options)
      @page     = wiki.page(@name)
      @page_num = [params[:page].to_i, 1].max
      @versions = @page.versions :page => @page_num
      mustache :history
    end

    post "#{settings.mount_point}/compare/:name" do
      @mount_point = settings.mount_point
      @versions = params[:versions] || []
      if @versions.size < 2
        redirect "#{settings.mount_point}/history/#{CGI.escape(params[:name])}"
      else
        redirect "#{settings.mount_point}/compare/%s/%s...%s" % [
          CGI.escape(params[:name]),
          @versions.last,
          @versions.first]
      end
    end

    get "#{settings.mount_point}/compare/:name/:version_list" do
      @mount_point = settings.mount_point
      @name     = params[:name]
      @versions = params[:version_list].split(/\.{2,3}/)
      wiki      = Gollum::Wiki.new(settings.gollum_path, settings.wiki_options)
      @page     = wiki.page(@name)
      diffs     = wiki.repo.diff(@versions.first, @versions.last, @page.path)
      @diff     = diffs.first
      mustache :compare
    end

    get "#{settings.mount_point}/_tex.png" do
      @mount_point = settings.mount_point
      content_type 'image/png'
      formula = Base64.decode64(params[:data])
      Gollum::Tex.render_formula(formula)
    end

    get %r{^#{settings.mount_point}/(javascript|css|images)} do
      halt 404
    end

    get %r{#{settings.mount_point}/(.+?)/([0-9a-f]{40})} do
      @mount_point = settings.mount_point
      name = params[:captures][0]
      wiki = Gollum::Wiki.new(settings.gollum_path, settings.wiki_options)
      if page = wiki.page(name, params[:captures][1])
        @page = page
        @name = name
        @content = page.formatted_data
        @editable = true
        mustache :page
      else
        halt 404
      end
    end

    get "#{settings.mount_point}/search" do
      @mount_point = settings.mount_point
      @query = params[:q]
      wiki = Gollum::Wiki.new(settings.gollum_path, settings.wiki_options)
      @results = wiki.search @query
      @name = @query
      mustache :search
    end

    get "#{settings.mount_point}/pages" do
      @mount_point = settings.mount_point
      wiki = Gollum::Wiki.new(settings.gollum_path, settings.wiki_options)
      @results = wiki.pages
      @ref = wiki.ref
      mustache :pages
    end

    get "#{settings.mount_point}/*" do
      @mount_point = settings.mount_point
      show_page_or_file(params[:splat].first)
    end

    def show_page_or_file(name)
      @mount_point = settings.mount_point
      wiki = Gollum::Wiki.new(settings.gollum_path, settings.wiki_options)
      if page = wiki.page(name)
        @page = page
        @name = name
        @content = page.formatted_data
        @editable = true
        mustache :page
      elsif file = wiki.file(name)
        content_type file.mime_type
        file.raw_data
      else
        @name = name
        mustache :create
      end
    end

    def update_wiki_page(wiki, page, content, commit_message, name = nil, format = nil)
      return if !page ||
        ((!content || page.raw_data == content) && page.format == format)
      name    ||= page.name
      format    = (format || page.format).to_sym
      content ||= page.raw_data
      wiki.update_page(page, name, format, content.to_s, commit_message)
    end

    def commit_message
      { :message => params[:message] }
    end

  end
end

module Gollum

  class Markup
     def process_page_link_tag(tag)
      parts = tag.split('|')
      parts.reverse! if @format == :mediawiki

      name, page_name = *parts.compact.map(&:strip)
      cname = @wiki.page_class.cname(page_name || name)

      if name =~ %r{^https?://} && page_name.nil?
        %{<a href="#{name}">#{name}</a>}
      else
        presence    = "absent"
        link_name   = cname
        page, extra = find_page_from_name(cname)
        if page
          link_name = @wiki.page_class.cname(page.name)
          presence  = "present"
        end
        link = ::File.join(@wiki.base_path, CGI.escape(link_name))
        %{<a class="internal #{presence}" href="#{WikiMounter.mount_point}#{link}#{extra}">#{name}</a>}
      end
    end
  end
end
