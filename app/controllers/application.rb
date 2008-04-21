# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  
  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery :secret => 'f9b96ef11a175222b63fb0f72cff2fa4qwerty'
  filter_parameter_logging(:login,:password)
  def login_required
    unless prepare_session
      flash[:notice]='Sesja wygasła.<br> Prosze zalogowac sie w systemie'
      redirect_to_login
      return false 
    end
    return true if [:user_login] && session[:user_id]
    session[:user_id] = session[:user_login] = nil
    flash[:notice]='Prosze zalogowac sie w systemie'
    #    redirect_to :controller => "authentication", :action => "login"
    redirect_to_login
    return false 
  end
  def redirect_to_stored
    if session[:return_to]
      return_to = session[:return_to]
      session[:return_to]=nil
      redirect_to(return_to)
    else
      redirect_to :controller => "authentication", :action => "login"
    end
  end
  def redirect_to_login
    if request.xhr?
      render(:update) do |page|
        page.redirect_to :controller => "authentication", :action => "login"
        return
      end 
    else
      redirect_to :controller => "authentication", :action => "login"
    end
  end
  def redirect_to_welcome
    redirect_to :controller=>"view" , :action=>"welcome"
  end
  def prepare_session
    puts "prepare_session : #{session[:expiry_time]}"
    if !session[:expiry_time].nil? and session[:expiry_time] < Time.now
      # Session has expired. Clear the current session.
      reset_session
      return false
    end
    # Assign a new expiry time, whether the session has expired or not.
    set_session_expire
    return true
  end
  def set_session_expire
    session[:expiry_time] = MAX_SESSION_TIME.seconds.from_now
  end
  def random_string(len)
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    newpass = ""
    1.upto(len) { |i| newpass << chars[rand(chars.size-1)] }
    return newpass
  end
  def encrypt(pass, secure)
    Digest::SHA1.hexdigest(pass+secure)
  end
  def random_color
    array = %w( black  red green blue)
    return array[rand(array.size)]
  end
  def random_register_image
    random_path "#{RAILS_ROOT}/public/images/register_background", '.png'
  end

  def random_font
    random_path "#{RAILS_ROOT}/artwork/fonts", '.ttf'
  end
  def random_path(path,ext)
    array = []
    Dir.foreach(path) do |x|
      file = path+"/"+x
      if File.file?(file) && File.extname(file).eql?(ext) # font file
        array << file
      end
    end
    return array[rand(array.size)]
  end
end
