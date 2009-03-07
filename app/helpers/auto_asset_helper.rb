# Out of the box the auto asset helpers attemp to include javascript and css files based on the 
# controller and action names. You can of course customize the logic that generates the path for
# each page.
#
#
# Simple Usage: 
#   Add these lines to your layout
#     stylesheet_link_tag :auto_includes
#     javascript_include_tag :auto_includes
#
# Advanced Usage:
#   You can overwrite the method that generates the resource path by defining one of the followig
#   methods in any controller
#     asset_path_generator
#     javascript_path_generator
#     stylesheet_path_generator
# 
#   Examples:
#     class ApplicationController
#       def asset_path_generator(asset_type)
#         File.join( 'auto_included_assets', "/#{asset_type.to_s.pluralize}/", params['controller'], params['action'] ) 
#       end
#     end
#
#     class PostsController
#       def stylesheet_path_generator
#         File.join( 'posts_style_sheets', cobrand_name, params['action'] ) 
#       end
#     end
# 
module AutoAssetHelper
  
  # Usage: 
  #   stylesheet_link_tag :auto_includes
  def stylesheet_link_tag(*sources)
    expand_auto_includes(:stylesheet, sources)
    super
  end
  
  # Usage: 
  #   javascript_include_tag :auto_includes
  def javascript_include_tag(*sources)
    expand_auto_includes(:javascript, sources)
    super
  end
  
  private
  
  def expand_auto_includes(asset_type, sources)
    sources.map!{ |source| 
      !source.eql?(:auto_includes) ? source : AutoAssetHelper.asset_for( asset_type, @controller )
    }.compact!
  end
  
  public
  
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
      "/#{asset_type.to_s.pluralize}/" + File.join( controller.params['controller'], controller.params['action'] ) 
    end
    
    def asset_for(asset_type, controller, *options)
      genrator_name = "#{asset_type}_path_generator".to_sym
      path = begin
        # if controller.javascript_path_generater is defined
        if controller.respond_to? genrator_name
          controller.send( genrator_name, *options )

        # if controller.asset_path_generator is defined        
        elsif controller.respond_to? :asset_path_generator
          controller.asset_path_generator( asset_type, *options )
          
        # user default asset path generator
        else
          default_path_generator( asset_type, controller, *options )
        end
      end
      asset_exists?(path, asset_type) ? path : nil
    end
    
    def asset_exists?(path, asset_type=nil)
      path = asset_type.nil? ? path : "#{path}.#{ASSET_TYPES[asset_type]}"
      ApplicationController.logger.debug "Checking exististance of #{path}"
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

AutoAssetHelper.add_asset_type(:stylesheet, :css)
AutoAssetHelper.add_asset_type(:javascript, :js)