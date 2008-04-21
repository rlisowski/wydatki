class AuthenticationController < ApplicationController
  layout 'register'
  def login
    puts "login"
    if request.post?
      user = User.authenticate(params[:user][:login], params[:user][:password])
      if user
        set_session_expire
        session[:user_login] = user.login
        session[:user_id] = user.id
        session[:logged_at] = ''
        session[:logged_at] =  user.logged_at if user.logged_at
        user.logged_at = Time.now
        user.save
        flash[:notice]  = "Zalogowano"
        redirect_to_welcome
        #        redirect_to :controller=>"view" , :action=>"welcome"
      else
        flash[:notice] = "Nie udało się zalogować"
      end
    else
      render :action => "login"
    end
  end
  def logout
    session[:user_login] = nil
    session[:user_id] = nil
    flash[:notice] = "Wylogowano"
    reset_session
    redirect_to :action => "login"
  end
  
  def register
    if request.post? 
      @user = User.new(params[:user])
      if      session[:register_validation_string].eql?(encrypt(params[:user][:register_text],IMAGE_VALIDATION_SECURE))
        #    if user.valid?
        if @user.save
          session[:user_login] = @user.login
          session[:user_id] = @user.id
          session[:logged_at] = ''
          session[:logged_at] =  @user.logged_at if @user.logged_at
          flash[:notice] = "User was saved"
          #      redirect_to :controller=>"view" , :action=>"welcome"
          redirect_to_welcome
        else
          @user.register_text = "przepisz poprawnie"
          flash[:notice] = "Cannot save user"
          render :action=>"register", :layout => "register"
          #      redirect_to :action=>"register"
        end
      else
        @user.register_text = "przepisz poprawnie"
        flash[:register_validation_error] = "przepisz poprawnie"
        render :layout => "register"
      end
    else
      @user = User.new
      render :layout => "register"
    end
  end
  
  # TODO: make it useable  
  def forgot_password
    if request.post?
      u= User.find_by_email(params[:user][:email])
      if u and u.send_new_password
        flash[:notice]  = "A new password has been sent by email."
        redirect_to :action=>'login'
      else
        flash[:notice]  = "Couldn't send password"
      end
    end
  end
  
end
