# The auto assets helpers use a customizable convention to automatically include css and js files
#
# Simple Usage: 
#   Simply call the following wherever you'd like the corresponding css and js files to be linked
#     stylesheet_link_tag :auto_includes %>
#     javascript_include_tag :auto_includes
#
#   Exmaple
#   /layouts/application.html
#     <%= stylesheet_link_tag :auto_includes %>
#     <%= javascript_include_tag :auto_includes %>
#
# Advanced Usage
# 
#   # point the path generator at a method off the controller
#   AutoIncludeHelper.path_generator = lambda do |controller|
#     controller.asset_path_generator
#   end
# 
#   # set a global asset path generator
#   class ApplicationController
#     def asset_path_generator(controller)
#       File.join( 'awesome_sauce', controller.params['action']  )
#     end
#   end
# 
#   # set a controller specific asses path generator
#   class PostsController.rb
#     def asset_path_generator(controller)
#       File.join( 'awesome_sauce', controller.params['action']  )
#     end
#   end
# 
# 
  
module AutoAssetsHelper
  
  # Usage: 
  #   stylesheet_link_tag :auto_includes
  def stylesheet_link_tag(*sources)
    options = sources.extract_options!.stringify_keys
    sources.map!{ |s| s.eql?(:auto_includes) ? AutoAssetsHelper.path(@controller) : s }
    super
  end
  
  # Usage: 
  #   javascript_include_tag :auto_includes
  def javascript_include_tag(*sources)
    options = sources.extract_options!.stringify_keys
    sources.map!{ |s| s.eql?(:auto_includes) ? AutoAssetsHelper.path(@controller) : s }
    super
  end

  class << self
    
    # The default path generator simple joins the controller name and action name but is 
    # capable of generating paths based on any controller attribute
    # Example
    #  http://www.example.com/posts
    #  # => /javascripts/posts/index.js
    #  # => /stylesheets/posts/index.css
    #
    #  http://www.example.com/posts/5
    #  # => /javascripts/posts/show.js
    #  # => /stylesheets/posts/show.css
    DEFAULT_PATH_GENERATOR = lambda do |controller|
      File.join( controller.params['controller'], controller.params['action'] )     
    end
    
    # Allows you to set a custom path_generater lambda
    attr_accessor :path_generator
    
    # Generates the path to auto included resources from any the controller attributes
    # See DEFAULT_PATH_GENERATOR
    def path(controller)
      (@path_generator || DEFAULT_PATH_GENERATOR).call(controller)
    end
    
  end
  
end