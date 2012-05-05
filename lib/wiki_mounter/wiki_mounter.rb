class WikiMounter
  require 'rubygems'

  # $path = gollum_path

  def self.call(env)
    wikis_root = "wikis/"
    wiki_name = env["action_dispatch.request.path_parameters"][:wiki]
    wiki_path = wikis_root + wiki_name

    @@mount_point = "/wiki/" + wiki_name
    load Rails.root + 'lib/gollum/lib/gollum/frontend/app.rb'
    Precious::App.set(:gollum_path, wiki_path)
    Precious::App.set(:wiki_options, {})

    Precious::App.call(env)
  end

  def self.mount_point
    @@mount_point
  end
end