class BlogController < ApplicationController
  
  def index
    redirect_to blog_posts_url
  end
  
end
