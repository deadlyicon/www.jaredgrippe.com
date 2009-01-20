module FormHelper
  
  def text_field(object_name, method, options = {})
    tag = super
    if options[:autosize]
      id = "#{sanitize_to_id(object_name)}_#{method}" || options[:id]
      tag << javascript_tag("Event.observe(window,'load',function(event){ $('#{id}').autoResize(); });")
    end
    tag
  end
  
end