JobExercise1::Application.routes.draw do
	match 'users(/:action(/:id)(.:format))', :controller => :users, :constraints => {:action => /index|edit|remove|show|available|follow|unfollow/, :id => /\d*/}
	root :to => "users#index"
end
