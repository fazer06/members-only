# == Route Map
#
#   Prefix Verb   URI Pattern          Controller#Action
#    posts GET    /posts(.:format)     posts#index
#          POST   /posts(.:format)     posts#create
# new_post GET    /posts/new(.:format) posts#new
#     root GET    /                    posts#index
#   signin GET    /signin(.:format)    sessions#new
#          POST   /signin(.:format)    sessions#create
#  signout DELETE /signout(.:format)   sessions#destroy
#

Rails.application.routes.draw do

	resources :posts, only: [:new, :create, :index]
	root 'posts#index'

	get     'signin'   =>  'sessions#new'
	post    'signin'   =>  'sessions#create'
	delete  'signout'  =>  'sessions#destroy'
  
end
