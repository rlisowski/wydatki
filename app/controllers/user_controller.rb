class UserController < ApplicationController
  layout 'main'
  before_filter :login_required
  
  def save
    @user = User.find(session[:user_id])
    if @user
      @user.update_attributes(params[:user])
      puts "==============",@user,@user.save_with_my_validation,"================"
      if  @user.save_with_my_validation
        puts @user.inspect
        flash[:notice] = "Zapisano pomyślnie."
      else
        flash[:notice] = "Nie udało się zapisać.Sprawdź poprawność danych."
      end
    else
      flash[:notice] = "Nie ma takiego uytkownika."
    end
    
    redirect_to :controller=>"view", :action=>"abaut_me"
  end
  
end
