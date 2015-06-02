Smithers::Application.routes.draw do
  devise_for :users
  root to: 'home#index'

  resources :customers
  
  resources :invoices do
    resources :items, only: [:create, :update, :destroy]
    post 'send_email', on: :member
  end
  
  resources :projects do
    get 'time_tracking_counters', on: :member
    get 'tracked_time', on: :member
    get 'last_invoiced_period', on: :member
  end

  resources :bank_records, path: 'balance' do
    get 'evolution', on: :collection
    get 'income_expenses', on: :collection
  end
end
