module Blog
  class PostsController < BlogController 
    
    before_filter :has_admin_access?, :except => [:index, :show]
    
    # GET /posts
    # GET /posts.xml
    def index
      # TODO check for rss format
      # if params[:format].eql? :rss
        # get last x by datetime from now
      # else
        @posts = Post.paginate(:page => params[:page], :per_page => 5, :include => :tags, :order => 'created_at ASC')
      # end
      
      respond_to do |format|
        format.html # index.html.erb
        format.xml  { render :xml => @posts }
        format.json { render :json => @posts }
        format.js   { render :file => '/blog/posts/posts.js.rjs' }
        format.rss
      end
    end

    # GET /posts/1
    # GET /posts/1.xml
    # GET /posts/2009/1/21/the-post-title
    # GET /posts/2009/1/21/the-post-title.xml
    def show
      @post = Post.find_by_param(params[:id], :include => :tags ) #TODO eager load tags

      respond_to do |format|
        if @post
          format.html # show.html.erb
          format.xml  { render :xml => @post }
          format.json { render :json => @post }
        else
          format.html { render :text => '404', :status => 404 }
          format.xml  { render :xml => '404', :status => 404 }
          format.json { render :json => '404', :status => 404 }
        end
      end
    end

    # GET /posts/new
    # GET /posts/new.xml
    def new
      @post = Post.new

      respond_to do |format|
        format.html # new.html.erb
        format.xml  { render :xml => @post }
        format.json { render :json => @post }
      end
    end

    # GET /posts/1/edit
    def edit
      @post = Post.find_by_param(params[:id])
    end

    # POST /posts
    # POST /posts.xml
    def create
      @post = Post.new(params[:blog_post])

      respond_to do |format|
        if @post.save
          flash[:notice] = 'Post was successfully created.'
          format.html { redirect_to :action => 'show' }
          format.xml  { render :xml  => @post, :status => :created, :location => @post }
          format.json { render :json => @post, :status => :created, :location => @post }
        else
          format.html { render :action => "new" }
          format.xml  { render :xml  => @post.errors, :status => :unprocessable_entity }
          format.json { render :json => @post.errors, :status => :unprocessable_entity }
        end
      end
    end

    # PUT /posts/1
    # PUT /posts/1.xml
    def update
      @post = Post.find_by_param(params[:id])

      respond_to do |format|
        if @post and @post.update_attributes(params[:blog_post])
          flash[:notice] = 'Post was successfully updated.'
          format.html { redirect_to url_for( @post ) }
          format.xml  { head :ok }
          format.json { head :ok }
        else
          format.html { render :action => "edit" }
          format.xml  { render :xml  => @post.errors, :status => :unprocessable_entity }
          format.json { render :json => @post.errors, :status => :unprocessable_entity }        
        end
      end
    end

    # DELETE /posts/1
    # DELETE /posts/1.xml
    def destroy
      @post = Post.find_by_param(params[:id])
      @post.destroy

      respond_to do |format|
        format.html { redirect_to :action => 'index' }
        format.xml  { head :ok }
        format.json { head :ok }
      end
    end
    
    def url_for(options={})
      if options.is_a? Blog::Post or options[:id].is_a? Blog::Post
         CGI::unescape super
      else
        super
      end
    end
    
  end
end