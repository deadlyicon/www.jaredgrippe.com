module JavascriptHelper
  
  # Example Usage:
  # javascript_tag(:anonymous => true, :on => :load) do; ... end
  # 
  # javascript_tag( 'alert("dom ready")', :on => 'dom:loaded')
  #
  def javascript_tag(content_or_options_with_block = nil, html_options = {}, &block)
    content = if block_given?
      html_options = content_or_options_with_block if content_or_options_with_block.is_a?(Hash)
      capture(&block)
    else
      content_or_options_with_block
    end
    
    if html_options[:on]
      content = javascript_on_event_block( html_options[:on], content, :anonymous => html_options[:anonymous] )
    elsif html_options[:anonymous]
      content = javascript_anonymous_block(content)
    end

    tag = content_tag(:script, content, html_options.merge(:type => Mime::JS))

    if block_called_from_erb?(block)
      concat(tag)
    else
      tag
    end
  end
  
  # Wraps a string in a self executing anonymous JS block/function
  def javascript_anonymous_block(content) #:nodoc:
    "\n(function(){\n#{content}\n})();\n"
  end
  
  # Example Usage:
  #  javascript_on_event_block(:load, 'alert("loaded")' )
  #  javascript_on_event_block(:click, 'alert("clicked")', :element => 'myButton', :anonymous => true ))
  def javascript_on_event_block(on, content, options = {})
    options[:element] ||= 'window'
    if options[:anonymous]
      "\nEvent.observe(#{options[:element]},'#{on}',function(event){\n#{content}\n});\n"
    else
      "\nEvent.observe(#{options[:element]},'#{on}',function(event){\n#{content}\n}.bindAsEventListener(window));\n"
    end
  end

  def javascript_environment_variables
    javascript_tag "window.ENV = #{JS::ENV.to_json};", :anonymous => false
  end

end