module EndlessPageHelper
  
  # Setsup the page to load more content as the user scrolls toward the bottom
  #
  # Options:
  #   collection_name
  #   total_pages
  #   url
  #   render
  # 
  # Examples:
  #   endless_page_for @posts
  #
  #   endless_page_for @posts do |post|
  #     render :partial => post
  #   end
  #
  #  endless_page_for @posts, :collection_name => 'blogs', :render => { :partial => 'blog_post', :collection => @posts }
  #
  def endless_page_for(collection, *args, &block)
    model = collection.first.class
    opts = {
      :collection_name => model.class_name.downcase.pluralize,
      :total_pages => collection.total_pages,
      :url => "#{url_for(collection.first.class.new)}.js",
      :render => { :partial => collection }
    }.merge(args.first || {})
    
    content = ''
    if block_given?
      content = collection.inject(''){|html, item| html += capture(item, &block) }
    else
      content = render(opts[:render])
    end
    # content = block_given? ? capture('sex', &block) : render(opts[:render])
        
    concat javascript_include_tag 'endless_page'
    concat "\n"
    concat javascript_anonymous_tag <<-SCRIPT
      EndlessPage.totalPages = #{collection.total_pages};
      EndlessPage.url = '#{url_for(collection.first.class.new)}.js';
      
      EndlessPage.observe('nearBottom', function(event){
        console.dir({nearBottom:event});

      });
    SCRIPT
    concat "\n"
    concat content_tag(:div, content, :id => opts[:collection_name])
    concat "\n"
    concat content_tag(:div, 'Loading...', :id => "loading_#{opts[:collection_name]}")
    ''
  end
  
end