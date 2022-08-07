# required?
# frozen_string_literal: true

Rails.application.routes.draw do
  resources :orders
  root to: "orders#index"
end
