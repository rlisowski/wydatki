class DataController < ApplicationController
  before_filter :login_required
  
  # bill_parts
  def save_bill_part
    
    params[:bill_part][:price] = params[:bill_part][:price].gsub(',','.')
    params[:bill_part][:count] = params[:bill_part][:count].gsub(',','.')
    params[:bill_part][:price_summary] = params[:bill_part][:count].to_f*params[:bill_part][:price].to_f
    @bill_part = BillPart.new(params[:bill_part])
    if @bill_part.save
      @count=BillPart.count_by_sql("select count(id) from bill_parts where bill_id='#{params[:bill_part][:bill_id]}'")
    else
      @count = nil      
    end
    return if request.xhr?
  end
  def edit_bill_part
    @bill_part = BillPart.find(params[:bill_part_id])
    @count = params[:count]
    puts @bill_part.inspect
    return if request.xhr?
  end
  def delete_bill_part
    bill_part = BillPart.find(params[:bill_part_id])
    if bill_part.removable? && bill_part.destroy
      @result = true
      flash[:notice] = "Usunięto produkt z rachunku."
    else
      @result = false
      flash[:notice] = "Nie da się usunąć produktu z rachunku."
    end
    return if request.xhr?
  end
  def update_bill_part
    params[:bill_part][:price] = params[:bill_part][:price].gsub(',','.')
    params[:bill_part][:price_summary] = params[:bill_part][:count].to_i*params[:bill_part][:price].to_f
    @bill_part = BillPart.find(params[:bill_part][:id])
#    params[:bill_part].delete(:id)
    @bill_part.update_attributes(params[:bill_part])
    if @bill_part.save
      @count = params[:count]
    else
      @count = nil      
    end
    return if request.xhr?
  end
  
  
  #  bill
  def save_bill
    params[:bill][:user_id] = session[:user_id]
    @bill = Bill.new(params[:bill])
    if @bill.save
      @count=Bill.count_by_sql("select count(id) from bills where user_id='#{session[:user_id]}' ")
    else
      @count = nil      
    end
    return if request.xhr?
  end
  def edit_bill
    @bill = Bill.find(params[:bill_id])
    @count = params[:count]
    puts @bill.inspect
    return if request.xhr?
  end
  def delete_bill
    bill = Bill.find(params[:bill_id])
    if bill.removable? && bill.destroy
      @result = true
      flash[:notice] = "Usunięto rachunek."
    else
      @result = false
      flash[:notice] = "Nie da się usunąć rachunku."
    end
    return if request.xhr?
  end
  def update_bill
    @bill = Bill.find(params[:bill][:id])
    @bill.update_attributes(params[:bill])
    if @bill.save
      @count = params[:count]
    else
      @count = nil      
    end
    return if request.xhr?
  end

  #  category
  def save_category
    params[:category][:user_id] = session[:user_id]
    @category = Category.new(params[:category])
    #@category.update_attributes(params[:category])
    if @category.save
      @count=Category.count_by_sql("select count(id) from categories where user_id='#{session[:user_id]}' ")
    else
      @count = nil      
    end
    return if request.xhr?
  end
  def edit_category
    @category = Category.find(params[:category_id])
    @count = params[:count]
    puts @category.inspect
    return if request.xhr?
  end
  def delete_category
    category = Category.find(params[:category_id])
    if category.removable? && category.destroy
      @result = true
      flash[:notice] = "Usunięto kategorie."
    else
      @result = false
      flash[:notice] = "Nie da się usunąć kategorii."
    end
    return if request.xhr?
  end
  def update_category
    @category = Category.find(params[:category][:id])
    @category.update_attributes(params[:category])
    if @category.save
      @count = params[:count]
    else
      @count = nil      
    end
    return if request.xhr?
  end
  
  # place
  def save_place
    params[:place][:user_id] = session[:user_id]
    @place = Place.new(params[:place])
    if @place.save
      @count=Place.count_by_sql("select count(id) from places where user_id='#{session[:user_id]}' ")
    else
      @count = nil      
    end
    return if request.xhr?
  end
  def edit_place
    @place = Place.find(params[:place_id])
    @count = params[:count]
    puts @place.inspect
    return if request.xhr?
  end
  def delete_place
    place = Place.find(params[:place_id])
    if place.removable? && place.destroy
      @result = true
      flash[:notice] = "Usunięto miejsce."
    else
      @result = false
      flash[:notice] = "Nie da się usunąć miejsca. Dane są używane."
    end
    return if request.xhr?
  end
  def update_place
    @place = Place.find(params[:place][:id])
    @place.update_attributes(params[:place])
    if @place.save
      @count = params[:count]
    else
      @count = nil      
    end
    return if request.xhr?
  end

end
