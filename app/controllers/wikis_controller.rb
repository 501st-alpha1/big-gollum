class WikisController < InheritedResources::Base
  def create
    @wiki = Wiki.new(params[:wiki])
    WikiInitializer.create_wiki(@wiki)
    create!(:notice => "Dude! Nice job creating that wiki.") { root_url }
  end
end
