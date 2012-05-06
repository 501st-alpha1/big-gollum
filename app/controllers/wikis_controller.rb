class WikisController < InheritedResources::Base
  def create
    @wiki = Wiki.new(params[:wiki])
    create! do |success, failure|
      success.html {
        WikiInitializer.create_wiki(@wiki)
        flash[:notice] = "Dude! Nice job creating that wiki."
        redirect_to root_url
      }

      failure.html {
        flash[:notice] = "Could not create wiki."
        render :new
      }
    end
  end

  def destroy
    @wiki = Wiki.find(params[:id])
    `rm -rf "#{Rails.root.to_s + '/wikis/' + @wiki.name}"`
    destroy!(:notice => "Wiki has been destroyed :(") { root_url }
  end
end