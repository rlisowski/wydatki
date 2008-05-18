class ActiveRecord::Base
  def show_errors
    ret = ''
    self.errors.each{|attr,msg| ret += "<i>#{msg}</i> <br>" }
    ret
  end
  def round(number = 0, place = 2)
    sprintf("%.#{place}f", number)
#    sprintf("%.2f", number)
  end
  def round_to_s(number = 0, place = 2)
    round(number,place)
  end
  def round_to_f(number = 0, place = 2)
    x = round(number,place)
    x.to_f
  end
end