module FormHelper
  
  def text_field(object_name, method, options = {})
    tag = super
    if options[:autosize]
      id = "#{sanitize_to_id(object_name)}_#{method}"
      tag << javascript_tag(<<-JS
        Event.observe(window,'load',function(event){
          $('#{id}').remove()
        });
      JS
      )
    end
    tag
  end
  
end