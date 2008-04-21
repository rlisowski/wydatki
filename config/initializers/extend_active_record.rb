class ActiveRecord::Base
  def show_errors
    ret = ''
    self.errors.each{|attr,msg| ret += "<i>#{msg}</i> <br>" }
    ret
  end
end