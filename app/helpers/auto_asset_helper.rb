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
#       File.join( 'more_better', controller.params['action']  )
#     end
#   end
# 
# 
  
module AutoAssetHelper
  
  # Usage: 
  #   stylesheet_link_tag :auto_includes
  def stylesheet_link_tag(*sources)
    options = sources.extract_options!.stringify_keys
    sources.map!{ |source| 
      !source.eql?(:auto_includes) ? source : AutoAssetHelper.stylesheet_for( @controller )
    }.compact!
    super
  end
  
  # Usage: 
  #   javascript_include_tag :auto_includes
  def javascript_include_tag(*sources)
    sources.map!{ |source| 
      !source.eql?(:auto_includes) ? source : AutoAssetHelper.javascript_for( @controller )
    }.compact!
    super
  end
  
  ASSETS_DIR  = ActionView::Helpers::AssetTagHelper::ASSETS_DIR
  ASSET_TYPES = {}
  
  class << self
    
    def asset_names
      ASSET_TYPES.keys
    end
    
    def asset_extensions
      ASSET_TYPES.values
    end

    def add_asset_type(asset_type, extension)
      ASSET_TYPES[asset_type] = extension
      # self.class.send :attr_accessor, "#{asset_type}_path_generator".to_sym
      # self.class.send :define_method, "#{asset_type}_for".to_sym do |controller, *args|
      #   asset_for(asset_type, controller, *args)
      # end
    end

    def default_path_generator(asset_type, controller)
      '/' + File.join( controller.params['controller'], controller.params['action'] ) 
    end
    
    def asset_for(asset_type, controller, *options)
      genrator_name = "#{asset_type}_path_generator".to_sym
      path = begin
        # if controller.javascript_path_generater is defined
        if controller.respond_to? genrator_name
          controller.send( genrator_name, asset_type, controller, *options )

        # if controller.asset_path_generator is defined        
        elsif controller.respond_to? :asset_path_generator
          controller.asset_path_generator( asset_type, controller, *options )
          
        # user default asset path generator
        else
          default_path_generator( asset_type, controller, *options )
        end
      end
      asset_exists?(path, asset_type) ? path : nil
    end
    
    def asset_exists?(path, asset_type=nil)
      path = asset_type.nil? ? path : "#{path}.#{ASSET_TYPES[asset_type]}"
      assets.include? path
    end

    def assets
      ApplicationController.logger.debug "Searching for auto includable assets"
      asset_extensions.inject([]){ |assets, asset_ext|
        assets.concat Dir[File.join(ASSETS_DIR,'**',"*.#{asset_ext}")]
      }.map{|a| a.sub(ASSETS_DIR ,'')}
    end
    memoize :assets if RAILS_ENV.downcase.match('production')

  end
  
end

AutoAssetHelper.add_asset_type('stylesheet', 'css')
AutoAssetHelper.add_asset_type('javascript', 'js')