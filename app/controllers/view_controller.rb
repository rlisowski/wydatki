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
  def graphs
    return if request.xhr?
    redirect_to_welcome
  end
  def place_graph
    places = Place.find_all_by_user_id session[:user_id], :order=>"name ASC"
    
    all = Bill.count('id',:conditions=>["user_id = ?",session[:user_id]]) 
    
    @data = []
    places.each do |place|
      count =  Bill.count('id',:conditions=>["place_id = ?",place.id]) 
      if count!=0
        @data << [place.name, count, all, format("%.2f",(count.to_f/all.to_f)*100)]
      end
    end
    
    @graph = open_flash_chart_object(400,400, '/graph/place')    
    return if request.xhr?
    redirect_to_welcome
  end
  def category_graph
    categories = Category.find_all_by_user_id session[:user_id], :order=>"name ASC"
    
    all = BillPart.count('id',:conditions=>["user_id = ?",session[:user_id]]) 
    
    @data = []
    categories.each do |category|
      count =  BillPart.count('id',:conditions=>["category_id = ?",category.id]) 
      if count!=0
        @data << [category.name, count, all, format("%.2f",(count.to_f/all.to_f)*100)]
      end
    end
    
    @graph = open_flash_chart_object(400,400, '/graph/category')    
    return if request.xhr?
    redirect_to_welcome
  end
  def bill_graph
    return if request.xhr?
    redirect_to_welcome
  end
end
