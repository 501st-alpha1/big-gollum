BigGollum::Application.routes.draw do
    root :to => 'wikis#index'
    match "/wiki/:wiki(/*other)", :to => WikiMounter, :anchor => true, :as => "mounted_wiki"
    resources :wikis, :only => [:index, :create, :new, :destroy]
end
