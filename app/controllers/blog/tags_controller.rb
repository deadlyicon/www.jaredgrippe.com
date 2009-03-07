module Blog
  class TagsController < BlogController 
    
    def index
      @tags = Post.tag_counts
    end
    
    # GET /posts/tags/funny
    # GET /posts/tags/awesome+weird
    # GET /posts/tags/lame+sexy+fun.xml
    def show
      @tags = params[:id].split(/\+|\s+/)
      find_tags_options = Post.find_options_for_find_tagged_with(@tags, :include => :tags)
      find_tags_options.merge!({
        :page => params[:page],
        :per_page => 5
      })      
      @posts = Post.paginate( :all, find_tags_options )

      unless @posts
        #render 404
      end

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