Rails.application.routes.draw do
  get 'welcome/index'
  get 'result_date', to: 'posts#result_date'
  get 'result_category', to: 'posts#result_category'
  get '/users/show_comments', to: 'users#show_comments'
  get '/admins/show_comments', to: 'admins#show_comments'
  get '/admins/show_feedbacks', to: 'admins#show_feedbacks'
  get '/posts/:id/audit_success', to: 'posts#audit_success'
  get '/posts/:id/audit_failed', to: 'posts#audit_failed'
  get '/posts/:id/admin', to: 'posts#show_admin', as: 'post_show_admin'
  get '/comments/:id/audit_success', to: 'comments#audit_success'
  get '/comments/:id/audit_failed', to: 'comments#audit_failed'

  resources :users
  resources :admins
  resources :sessions
  resources :sessions_admin
  resources :posts do
    resources :comments
  end
  resources :feedbacks

  root 'welcome#index'
end
