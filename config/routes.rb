BetchaServer::Application.routes.draw do

  resources :badge_types

  devise_for :users, :path => 'accounts', :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" } #, :path => 'accounts'
  resources :tokens

  resources :users do
    collection do
      get :show_by_email
      get :show_by_uid
      get :show_details
      put :reset_password
    end
    resources :friends do
      collection do
        get :show_for_user
        get :show_updates_for_user
      end
    end
    resources :user_stats do
      collection do
        get :show_for_user
      end
    end
    resources :badges do
      collection do
        get :show_for_user
        get :show_updates_for_user
      end
    end
  end

  resources :activity_events  do
    collection do
      get :show_for_user
      get :show_updates_for_user
    end
  end

  resources :locations

  resources :stakes

  resources :topic_categories do
    member do
      get :show_details
    end
    resources :topics do
      member do
        get :show_details
      end
      collection do
        get :show_for_category
      end
      resources :prediction_options do
        collection do
          get :show_for_topic
        end
      end
      resources :topic_results do
        collection do
          get :show_for_topic
        end
      end
    end
  end
  
  resources :bets do
    member do
      put :update_or_create
    end
    collection do
      get :show_for_user
      get :show_updates_for_user
    end

    resources :predictions do
      member do
        get :submit
      end
      collection do
        get :show_for_bet
        get :show_updates_for_bet
        put :update_list
        post :create_and_invite
      end
    end

    resources :chat_messages do
      collection do
        get :show_for_bet
      end
    end

  end
  
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => 'users#show_details'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
