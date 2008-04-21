require 'singleton'
class GlobalStatistic
  include Singleton
  @@mutex = Mutex
  def initialize
    puts 'start initialize '
    sleep 2
    puts 'end initialize'
  end
  def select
    
  end
  def save
    @@mutex.synchronize {
      # access shared resource
    }
  end
end



