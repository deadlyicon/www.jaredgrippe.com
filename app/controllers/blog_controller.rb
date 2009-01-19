class BlogController < ApplicationController
  
  def index
    redirect_to :controller => Blog::PostsController, :action => 'list'
  end
  
end
