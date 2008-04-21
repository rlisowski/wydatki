# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def space_to_nbsp(string)
    "#{string}".gsub(/[ ]/, '&nbsp;')
  end
  def get_date(date,format="%Y/%m/%d %H:%M:%S")
    Time.parse("#{date}").strftime(format)
  end
  def logged?
    if session[:worker]
      return true
    end
    false
  end
  def places
    Place.find(:all, :conditions=>["user_id=?",session[:user_id]]).collect {|p| [ p.name, p.id ] }
  end
  def trunc(string ='' ,size=10, truncate_string = "..")
    truncate(string.to_s, size, truncate_string)
  end
  def error_messages(obj)
    ret = ''
        obj.errors.each{|attr,msg| ret += "<b>#{attr}</b> - <i>#{msg}</i> " }
    ret
  end
end
