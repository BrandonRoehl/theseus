Rails.application.routes.draw do
    # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
    root to: 'application#console'
    get '/:model', to: 'application#get'
    post '/:model', to: 'application#post'
end
