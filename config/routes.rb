Rails.application.routes.draw do
  root 'home#index'
  get 'home/index'
  get 'activity', to: 'home#activity'
  get 'analytics', to: 'home#analytics'
  get 'privacy_policy', to: 'home#privacy_policy'

  namespace :charts do
    get 'users_per_day'
    get 'enrollments_per_day'
    get 'course_popularity'
    get 'money_makers'
  end

  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  resources :users, only: %i[index edit show update]
  resources :youtube, only: %i[show]
  resources :tags, only: %i[index create destroy]

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
