Rails.application.routes.draw do

  #【管理者用】
  # URL /admin/sign_in ...
  devise_for :admin, skip: [:registrations, :passwords], controllers: {
    sessions: "admin/sessions"
  }

  #【会員用】
  # URL /users/sign_in ...
  devise_for :users, skip: [:passwords], controllers: {
    registrations: "public/registrations",
    sessions: 'public/sessions'
  }
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html


  root to: "public/homes#top"

  #【public/usersコントローラー】
  scope module: :public do
    get 'users/my_page' => 'users#show'
    get 'users/information/edit' => 'users#edit'
    patch 'users/information' => 'users#update'
    get 'users/unsubscribe' => 'users#unsubscribe'
    patch 'users/withdraw' => 'users#withdraw'
    get 'users/user_index' => 'users#user_index'
    delete 'users/destroy/:id' => 'users#destroy', as: 'destroy_user_post'
    get 'users/user_favorites' => 'users#user_favorites'
    # get 'users/myfavorites' => 'users#myfavorites'
  end

  #【public/postsコントローラー】
  scope module: :public do
    resources :posts, only:[:index, :new, :create, :show, :destroy] do
      resource :favorites, only: [:create, :destroy]
      resources :comments, only: [:create, :destroy]
    end
  end

  #【admin/homesコントローラ】
  namespace :admin do
    get '/' => 'homes#top'
  end

  #【admin/usersコントローラー】
  namespace :admin do
     resources :users, only:[:index, :show, :edit, :update]
  end

   #【admin/postsコントローラー】
  namespace :admin do
     resources :posts, only:[:index, :show, :destroy]
  end

  #【admin/categoriesコントローラー】
  namespace :admin do
    resources :categories, only:[:index, :create, :edit, :update, :destroy]
  end

end
