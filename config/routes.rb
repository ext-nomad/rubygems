Rails.application.routes.draw do
  root 'static_pages#landing_page'
  get 'activity', to: 'static_pages#activity'
  get 'analytics', to: 'static_pages#analytics'
  get 'privacy', to: 'static_pages#privacy'
  get 'terms', to: 'static_pages#terms'
  get 'support', to: 'static_pages#support'
  get 'about', to: 'static_pages#about'

  namespace :charts do
    get 'money_makers'
    get 'users_per_day'
    get 'course_popularity'
    get 'enrollments_per_day'
  end

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  resources :tags, only: %i[index create destroy]
  resources :users, only: %i[index edit show update]
  resources :youtube, only: %i[show]

  resources :chapters

  resources :enrollments do
    get :my_students, on: :collection
    member do
      get :certificate
    end
  end

  resources :courses, except: %i[edit update] do
    get :teaching, :pending_review, :learning, :unapproved, on: :collection
    member do
      get :analytics
      patch :approve
      patch :publish
    end
    resources :lessons, except: %i[index] do
      resources :comments, except: %i[index]
      put :sort
      member do
        delete :delete_video
      end
    end
    resources :enrollments, only: %i[new create]
    resources :course_wizard, controller: 'courses/course_wizard'
  end
end
