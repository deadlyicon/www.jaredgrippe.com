module Blog
  class TagsController < BlogController 
    
    # GET /posts/tags/funny
    # GET /posts/tags/awesome+weird
    # GET /posts/tags/lame+sexy+fun.xml
    def show
      # raise "SHOW: #{params.inspect}"
      @tags = params[:id].split(/\+|\s+/)
      find_tags_options = Post.find_options_for_find_tagged_with(@tags, :include => :tags)
      find_tags_options.merge!({
        :page => params[:page],
        :per_page => 2
      })
      # find_tags_options[:page] = params[:page]
      
      @posts = Post.paginate( :all, find_tags_options )
      
      # raise @posts.inspect
      
      # @posts = Post.find_tagged_with(@tags, :include => :tags)

      unless @posts
        #render 404
      end

      # GET this to render the same as post.index and pagination etc


      respond_to do |format|
        format.html
        format.xml  { render :xml => @post }
        format.json { render :json => @post }
        format.js   { render :file => '/blog/posts/posts.js.rjs' }
        format.rss        
      end
    end
    
    
  end
end