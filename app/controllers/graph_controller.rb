class GraphController < ApplicationController
  #  before_filter :login_required
  
  

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

  def welcome
    g = Graph.new
    g.title( 'Sprawdź ile, jak często i na co wydajesz pieniądze!', '{color: #7E97A6; font-size: 20; text-align: center}' )
    g.set_bg_color('#b9fbd4')
    
    data = []
    (0..16).to_a.each do |x|
      data << 2*(x*x)-20*x + 55
      #      if x % 2 == 0
      #        data << x+400 
      #      else
      #        data << x+(x*20)
      #      end
    end
    (17..20).to_a.each do |x|
      #      data << x*2+450
      data << 2*(x*x) -20*x - 50
      #      if x % 2 == 0
      #        data << x+400 
      #      else
      #        data << x+(x*20)
      #      end
    end
    (21..31).to_a.each do |x|
      #      data << x*2+450
      data << (x*x) -20*x + 50
      #      if x % 2 == 0
      #        data << x+400 
      #      else
      #        data << x+(x*20)
      #      end
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
