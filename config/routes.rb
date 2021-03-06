ActionController::Routing::Routes.draw do |map|
  
  # Restful Authentication Rewrites
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.register '/register', :controller => 'users', :action => 'create'
  map.signup '/signup', :controller => 'users', :action => 'new'
  map.activate '/activate/:activation_code', :controller => 'users', :action => 'activate', :activation_code => nil
  map.forgot_password '/forgot_password', :controller => 'passwords', :action => 'new'
  map.change_password '/change_password/:reset_code', :controller => 'passwords', :action => 'reset'
  map.open_id_complete '/opensession', :controller => "sessions", :action => "create", :requirements => { :method => :get }
  map.open_id_create '/opencreate', :controller => "users", :action => "create", :requirements => { :method => :get }
  
  # /blog/posts
  map.with_options(:path_prefix => "blog", :namespace => "blog/", :name_prefix => "blog_") do |blog|
    blog.resources :posts, :requirements => {:id => /[^.\?]+/}
    blog.resources :tags,  :requirements => {:id => /[^.\?]+/}
  end
  
  map.blog '/blog', :controller => 'blog'
    
  map.resources :users
  map.resources :passwords
  map.resource  :session
  
  map.about_me '/aboutme', :controller => 'aboutme' # do |about_me|
   #    about_me.resume 'resume', :action => 'resume'
   #  end
  
  # Home Page
  
  map.root :controller => 'application', :action => 'redirect', :destination => {:controller => 'blog/posts', :action => 'index'}
      
  # Install the default routes as the lowest priority.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
  map.connect ':controller/:action.:format'
end
