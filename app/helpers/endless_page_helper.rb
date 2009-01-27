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
    collection_name = collection.empty? ? '' : collection.first.class.to_s.downcase.pluralize
    opts = {
      :collection_name => collection_name,
      :url => nil,
      :render => { :partial => collection }
    }.merge(args.first || {})
    
    content = ''
    if block_given?
      content = collection.inject(''){|html, item| html += capture(item, &block) }
    else
      content = "\n\n#{render(opts[:render])}\n\n"
    end
    # content = block_given? ? capture('sex', &block) : render(opts[:render])

    if collection.empty?
      concat content_tag(:div, content, :id => opts[:collection_name])      
    else
      concat javascript_include_tag( 'endless_page' )
      concat "\n"
      concat javascript_tag((<<-SCRIPT
        EndlessPage.contentElementId = $('#{opts[:collection_name]}');
        EndlessPage.url = '#{opts[:url] or url_for(:format => :js)}';
      SCRIPT
      ), :anonymous => true)
      concat "\n"
      concat content_tag(:div, content, :id => opts[:collection_name])
      concat "\n"
      concat content_tag(:div, "Loading more #{opts[:collection_name]}...", :id => "loading_#{opts[:collection_name]}")
    end
    ''
  end
  
end