module JavascriptHelper
  

  # TODO
  #   change this to wrap javascript_tag and accepts options
  #     :anonymous => true
  #     :on => :load | :dom-ready | :etc
  #
  def javascript_anonymous_tag(content_or_options_with_block = nil, html_options = {}, &block)
    content =
      if block_given?
        html_options = content_or_options_with_block if content_or_options_with_block.is_a?(Hash)
        capture(&block)
      else
        content_or_options_with_block
      end

    tag = content_tag(:script, javascript_anonymous_block(content), html_options.merge(:type => Mime::JS))

    if block_called_from_erb?(block)
      concat(tag)
    else
      tag
    end
  end

  def javascript_anonymous_block(content) #:nodoc:
    "\n(function(){\n#{content}\n})();\n"
  end

end