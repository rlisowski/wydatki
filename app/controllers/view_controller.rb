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
        @data << [place.name, count, all, round((count.to_f/all.to_f)*100)]
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
        @data << [category.name, count, all, round((count.to_f/all.to_f)*100)]
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
  def bill_graph_details
    price_from = (params['bill_graph']['price_from']['calosc']+'.'+params['bill_graph']['price_from']['grosze']).to_f
    price_to = (params['bill_graph']['price_to']['calosc']+'.'+params['bill_graph']['price_to']['grosze']).to_f
    
    year = params['bill_graph']['date_from(1i)']
    year = "0#{year}" if year.to_i < 10
    month = params['bill_graph']['date_from(2i)']
    month = "0#{month}" if month.to_i < 10
    day = params['bill_graph']['date_from(3i)']
    day = "0#{day}" if day.to_i < 10
    
    date_from = "#{year}-#{month}-#{day} 00:00:00"
    
    year = params['bill_graph']['date_to(1i)']
    year = "0#{year}" if year.to_i < 10
    month = params['bill_graph']['date_to(2i)']
    month = "0#{month}" if month.to_i < 10
    day = params['bill_graph']['date_to(3i)']
    day = "0#{day}" if day.to_i < 10
    
    date_to = "#{year}-#{month}-#{day} 24:00:00"
    
    query = []
    
    
    query << "price_summary >= '#{price_from}'" if price_from > 0
    query << "price_summary <= '#{price_to}'" if price_to > 0
    query << "spend_at >= '#{date_from}'"# unless date_from.eql?(Time.now.strftime('%Y/%m/%d'))
    query << "spend_at <= '#{date_to}'"# unless date_to.eql?(Time.now.strftime('%Y/%m/%d'))
      
    query = query.join(' and ')
    @data = Bill.find_all_by_user_id session[:user_id], :conditions=>["#{query}"]
    @graph = open_flash_chart_object(800,400, "/graph/bill_graph_details?#{params.to_query}")    
    return if request.xhr?
    redirect_to_welcome
  end
end
