class WikisController < InheritedResources::Base
  def create
    @wiki = Wiki.new(params[:wiki])
    WikiInitializer.create_wiki(@wiki)
    create!(:notice => "Dude! Nice job creating that wiki.") { root_url }
  end

  def destroy
    @wiki = Wiki.find(params[:id])
    `rm -rf #{Rails.root.to_s + '/wikis/' + @wiki.name}`
    destroy!(:notice => "Wiki has been destroyed :(") { root_url }
  end
end
