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
    # blog.resources :posts
    blog.resources :tags #, :requirements => {:id => /.+/} #TODO this should be set to something
  end
  

  
  
  # all this so i can have *slug instead of :slug =\
  map.blog_posts                  'blog/posts',         :action => 'index',   :controller => 'blog/posts', :conditions => { :method => :get }
  map.formatted_blog_posts        'blog/posts.:format', :action => 'index',   :controller => 'blog/posts', :conditions => { :method => :get }
  map.with_options(:path_prefix => "blog/posts", :controller => 'blog/posts') do |blog|
    blog.connect                  '*slug',              :action => 'create',  :conditions => { :method => :post   }
    blog.connect                  '*slug.:format',      :action => 'create',  :conditions => { :method => :post   }
    blog.new_blog_post            'new',                :action => 'new',     :conditions => { :method => :get    }
    blog.formatted_new_blog_post  'new.:format',        :action => 'new',     :conditions => { :method => :get    }
    blog.edit_blog_post           '*slug/edit',         :action => 'edit',    :conditions => { :method => :get    }
    blog.formatted_edit_blog_post '*slug/edit.:format', :action => 'edit',    :conditions => { :method => :get    }
    blog.blog_post                '*slug',              :action => 'show',    :conditions => { :method => :get    }
    blog.formatted_blog_post      '*slug.:format',      :action => 'show',    :conditions => { :method => :get    }
    blog.connect                  '*slug',              :action => 'update',  :conditions => { :method => :put    }
    blog.connect                  '*slug.:format',      :action => 'update',  :conditions => { :method => :put    }
    blog.connect                  '*slug',              :action => 'destroy', :conditions => { :method => :delete }
    blog.connect                  '*slug.:format',      :action => 'destroy', :conditions => { :method => :delete }
  end

  # map.formatted_blog_post '/blog/posts/*slug.:format', :controller => 'blog/posts', :action => 'show', :conditions => { :method => :get }  

  map.blog '/blog', :controller => 'blog'
  
  
  map.resources :users
  map.resources :passwords
  map.resource  :session
  
  map.about_me '/aboutme', :controller => 'aboutme'
  
  # Home Page
  
  map.root :controller => 'application', :action => 'redirect', :destination => {:controller => 'blog/posts', :action => 'index'}
      
  # Install the default routes as the lowest priority.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
  map.connect ':controller/:action.:format'
end
