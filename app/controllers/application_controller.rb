class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  before_action :authorize
  before_action :set_i18n_locale_from_params
  protect_from_forgery with: :exception

  protected



  def authorize
  	if request.format == Mime::HTML 
  		unless User.find_by(id: session[:user_id])
  			redirect_to login_url, notice: "Пожалуйста, пройдите авторизацию"
  		end
  	else
  		authenticate_or_request_with_http_basic do |username, password|
  			user = User.find_by(name: username)
  			user && user.authenticate(password)
  		end
  	end
  end

  def set_i18n_locale_from_params
  	if params[:locale]
  		if I18n.available_locales.map(&:to_s).include?(params[:locale])
  			I18n.locale = params[:locale]
  		else
  			flash.now[:notice] = 
  			"#{params[:locale]} translation not available"
  			logger.error flash.now[:notice]
  		end
  	end
  end

  def default_url_options
  	{ locale: I18n.locale }
  end

end
