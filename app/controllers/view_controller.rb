class ViewController < ApplicationController
  layout 'main'
  before_filter :login_required
  
  def bill_parts
    #    find all bill and display it paginated
    @bill_part=BillPart.new(:bill_id=>params[:bill_id])
    @bill_parts = BillPart.find :all, :order=>"created_at DESC",:conditions=>["bill_id=?",params[:bill_id]]
    return if request.xhr?
  end
  def bills
    #    find all bill and display it paginated
    @bills=Bill.new
    @bills = Bill.find :all, :order=>"created_at DESC",:conditions=>["user_id=?",session[:user_id]]
    return if request.xhr?
  end

  def categories
    @category=Category.new
    @categories = Category.find :all, :order=>"created_at DESC",:conditions=>["user_id=?",session[:user_id]]
    return if request.xhr?
  end

  def places
    @place=Place.new
    @places = Place.find :all, :order=>"created_at DESC",:conditions=>["user_id=?",session[:user_id]]
    return if request.xhr?
  end
  def abaut_me
    @user = User.find(session[:user_id])
  end
  def welcome
    @graph = open_flash_chart_object(600,300, '/graph/welcome')    
  end
  def index
    welcome
    render :action => "welcome"
  end
  
end
