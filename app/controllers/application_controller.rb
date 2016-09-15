class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  include NotificationHelper
  include ApplicationHelper

  before_action :user_agent

  def user_agent
    @ua_string = request.user_agent
  end

  def current_user=(user)
        puts "test " 
    @current_user = user
  end

  def current_user
        puts "current_user" 
        puts params[:auth_token] 
        puts params[:auth] 
        puts params[:email]
        
    if params[:auth_token]
         puts "auth_token " 
         puts params[:auth_token]
        @current_user ||= User.find_by(token: params[:auth_token])
       #  puts "current_user email"
      #   puts current_user.token
      #render json: { user: @current_user.as_resource(created: true) }
        # puts "done"

    elsif session[:token]
             puts "sessiontok" 
            puts session[:token]
      @current_user ||= User.where(token: session[:token], admin: true).first
       puts @current_user
    end
  end

  def logged_in?
        puts "test logged_in" 
        puts current_user
        
    !current_user.nil?
  end

  def logged_in_user
        puts "test logged_in" 
    unless logged_in?
      head status: 401
    end
  end

  # Return error message if user has not allowed notifications on the app
  def has_allowed_notifications
    if user_agent["iPhone"] && !@current_user.device_token
      head status: 424
    end
  end

  def check_location
    zipcode = params[:zip]
    if zipcode && ! Location::OPERATED_ZIPCODES.include?(zipcode)
      head status: 417
    end
  end

end
