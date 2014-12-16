Blog::Application.routes.draw do
  get "students/certificat"
  get "students/pay"


   get "account_to_semesters/pay"
   post "account_to_semesters/pay"

  post "pay_category_to_semesters/new"

  post "pay_category_to_semesters/new1"
  get "pay_category_to_semesters/new1"

  post "pay_category_to_semesters/kalkul"
  get "pay_category_to_semesters/kalkul"

  post "pay_category_to_semesters/stip1"
  get "pay_category_to_semesters/stip1"

  post "pay_category_to_semesters/stip2"
  get "pay_category_to_semesters/stip2"

  get "pay_to_month_students/pay_metod"
  post "pay_to_month_students/pay_metod"


  resources :operations

  resources :students do
    resources :certificats
    resources :student_groups
  end
  resources :groups
  resources :faculties do
    resources :account_to_semesters
  end
  resources :orders


  resources :student_groups
  resources :account_to_semesters

  resources :pay_category_to_semesters
  resources :pay_to_month_students
  resources :certificats
  resources :posts do
    resources :comments
  end
 root "welcome#index"

  get "static_pages/home"

  resources :users
  resources :sessions, only: [:new, :create, :destroy]
  #root  'static_pages#home'
  match '/signup',  to: 'users#new',            via: 'get'
  match '/signin',  to: 'sessions#new',         via: 'get'
  match '/signout', to: 'sessions#destroy',     via: 'delete'

  match '/help',    to: 'static_pages#help',    via: 'get'
  match '/about',   to: 'static_pages#about',   via: 'get'
  match '/contact', to: 'static_pages#contact', via: 'get'

  post "new_bases/group"
  get "new_bases/group"
  post "new_bases/student"
  get "new_bases/student"
  post "new_bases/student_group"
  get "new_bases/student_group"
  get "new_bases/new"
  post "new_bases/create_student_group"
  post "new_bases/create_student"
  post "new_bases/create_group"
end
