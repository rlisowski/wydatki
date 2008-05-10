class GraphController < ApplicationController
  before_filter :login_required, :except=>[:show_register_image]
  
  

  def show_register_image
    respond_to do |format|
      format.html do
        # Render the show.rhtml template
        redirect_to :controller=>'user', :action=>'register'
      end

      format.png do
        # Show cart icon with number of items in it
        icon = Magick::Image.read(random_register_image).first

        drawable = Magick::Draw.new
        drawable.pointsize = 32.0
        drawable.font = random_font
        drawable.fill = random_color
        drawable.gravity = Magick::CenterGravity

        # Tweak the font to draw slightly up and left from the center
        #        drawable.annotate(icon, 0, 0, -3, -6, @order.quantity.to_s)
        text = random_string(rand(3)+5).downcase
        drawable.annotate(icon, 0, 0, 0,0, text)
        
        session[:register_validation_string] = encrypt(text,IMAGE_VALIDATION_SECURE)
        

        send_data icon.to_blob, :filename => "register_validation.png", 
          :disposition => 'inline', 
          :type => "image/png" 
      end

    end
  end
  def place
    places = Place.find_all_by_user_id session[:user_id], :order=>"name ASC"
    
    all = Bill.count('id',:conditions=>["user_id = ?",session[:user_id]]) 
    
    data = []
    header = []
    places.each do |place|
      count =  Bill.count('id',:conditions=>["place_id = ?",place.id]) 
      if count!=0
        count = (count.to_f/all.to_f)*100
        data << format("%.2f",count)
        header << place.name
      end
    end
    g = Graph.new
    g.pie(60, '#505050', '{font-size: 12px; color: #404040;}')
    #    g.pie_values(data, %w(IE FireFox Opera Wii Other))
    g.pie_values(data, header)
    g.pie_slice_colors(%w(#d01fc3 #356aa0 #c79810))
    g.set_tool_tip("#val#%")
    g.title("Procent użycia miejsc", '{font-size:18px; color: #d01f3c}' )
    render :text => g.render

  end
  def category
    categories = Category.find_all_by_user_id session[:user_id], :order=>"name ASC"
    
    all = BillPart.count('id',:conditions=>["user_id = ?",session[:user_id]]) 
    
    data = []
    header = []
    categories.each do |category|
      count =  BillPart.count('id',:conditions=>["category_id = ?",category.id]) 
      if count!=0
        count = (count.to_f/all.to_f)*100
        data << format("%.2f",count)
        header << category.name
      end
    end
    g = Graph.new
    g.pie(60, '#505050', '{font-size: 12px; color: #404040;}')
    #    g.pie_values(data, %w(IE FireFox Opera Wii Other))
    g.pie_values(data, header)
    g.pie_slice_colors(%w(#d01fc3 #356aa0 #c79810))
    g.set_tool_tip("#val#%")
    g.title("Procent użycia kategorii", '{font-size:18px; color: #d01f3c}' )
    render :text => g.render

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
    date = "#{year}-#{month}-#{day} - "
    
    year = params['bill_graph']['date_to(1i)']
    year = "0#{year}" if year.to_i < 10
    month = params['bill_graph']['date_to(2i)']
    month = "0#{month}" if month.to_i < 10
    day = params['bill_graph']['date_to(3i)']
    day = "0#{day}" if day.to_i < 10
    
    date_to = "#{year}-#{month}-#{day} 24:00:00"
    date += "#{year}-#{month}-#{day}"
    
    query = []
    
    
    query << "price_summary >= '#{price_from}'" if price_from > 0
    query << "price_summary <= '#{price_to}'" if price_to > 0
    query << "spend_at >= '#{date_from}'"# unless date_from.eql?(Time.now.strftime('%Y/%m/%d'))
    query << "spend_at <= '#{date_to}'"# unless date_to.eql?(Time.now.strftime('%Y/%m/%d'))
      
    query = query.join(' and ')
    data = Bill.find_all_by_user_id session[:user_id], :conditions=>["#{query}"]
    
    price_table = []
    date_table = []
    max = 0
    data.each do |bill|
      price_table << bill.price_summary
      date_table << get_date(bill.spend_at,"%Y/%m/%d")
      max = bill.price_summary if bill.price_summary > max
    end
    
    g = Graph.new
    g.title( "Rachunki za okres #{} - #{date}", '{color: #7E97A6; font-size: 20; text-align: center}' )
    g.set_bg_color('#b9fbd4')
    g.set_data(price_table)
    g.line_hollow( 2, 4, '#164166', 'Ile', 10 )
    g.attach_to_y_right_axis(2)
    g.set_y_max(max)
    g.set_y_right_max(max)
    g.set_x_axis_color('#818D9D', '#F0F0F0' )
    g.set_y_axis_color( '#818D9D', '#ADB5C7' )
    g.y_right_axis_color('#818D9D')
    g.set_x_legend( 'Kiedy', 12, '#164166' )
    g.set_y_legend( 'Ile', 12, '#164166' )
    
    g.set_x_labels(date_table)
    g.set_x_label_style(10, '#164166', 2, 1, '#818D9D' )
    g.set_y_label_steps(15)
  
    render :text => g.render
  end
  def welcome
    g = Graph.new
    g.title( 'Sprawdź ile, jak często i na co wydajesz pieniądze!', '{color: #7E97A6; font-size: 20; text-align: center}' )
    g.set_bg_color('#b9fbd4')
    
    data = []
    (0..16).to_a.each do |x|
      data << 2*(x*x)-20*x + 55
    end
    (17..20).to_a.each do |x|
      data << 2*(x*x) -20*x - 50
    end
    (21..31).to_a.each do |x|
      data << (x*x) -20*x + 50
    end
    g.set_data(data)
    g.line_hollow( 2, 4, '#164166', 'Ile', 10 )
    g.attach_to_y_right_axis(2)
    g.set_y_max(600)
    g.set_y_right_max(600)
    g.set_x_axis_color('#818D9D', '#F0F0F0' )
    g.set_y_axis_color( '#818D9D', '#ADB5C7' )
    g.y_right_axis_color('#818D9D')
    g.set_x_legend( 'Kiedy', 12, '#164166' )
    g.set_y_legend( 'Na co', 12, '#164166' )
    tmp = []
    (0..31).to_a.each do |x|
      tmp << "#{x}"
    end
    g.set_x_labels(tmp)
    g.set_x_label_style(10, '#164166', 0, 1, '#818D9D' )
    g.set_y_label_steps(15)
  
    render :text => g.render
  end
end
