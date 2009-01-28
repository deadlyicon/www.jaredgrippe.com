module AboutmeHelper
  
  def stats(html_options={}, &block)
    content_tag(:table, {:id => 'stats'}.merge(html_options) ) do
      content_tag(:tbody, capture(&block))
    end
  end
  
  def stat( description, value=nil, &block)
    value = block_given? ? capture(&block) : value
    content_tag( :tr, :class => "stat #{description.to_s.underscore}" )do
      content_tag( :td, description.to_s.humanize, :class => 'description' ) + \
      content_tag( :td, value.to_s, :class => 'value' )
    end
  end
  
  def icon( name, url, options={} )
    link_to image_tag("aboutme/icons/#{name}"), url, :class => 'icon'
  end
  
end
