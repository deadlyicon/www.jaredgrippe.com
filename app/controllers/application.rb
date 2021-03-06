class ApplicationController < ActionController::Base
  include ExceptionNotifiable
  include AuthenticatedSystem
  include RoleRequirementSystem
  
  before_filter :update_stylesheets if RAILS_ENV == 'development'

  helper :all # include all helpers, all the time
  protect_from_forgery :secret => 'b0a876313f3f9195e9bd01473bc5cd06'
  filter_parameter_logging :password, :password_confirmation
  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found
  
  def admin?
    current_user.is_a? User and current_user.is_an_admin?
  end
  alias :current_user_is_an_admin? :admin?
  
  def has_admin_access?
    render :text => '404', :status => 404 unless admin?
  end
  
  def redirect # TODO post about this redirect method
    redirect_to( params['destination'] )
  end
  
  protected
  
  # Automatically respond with 404 for ActiveRecord::RecordNotFound
  def record_not_found
    render :file => File.join(RAILS_ROOT, 'public', '404.html'), :status => 404
  end
  
  def update_stylesheets
    logger.debug('updaing sass stylesheets')
    Sass::Plugin.update_stylesheets
  end
end
::LOGGER = ApplicationController.logger
