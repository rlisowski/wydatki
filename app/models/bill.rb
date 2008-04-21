class Bill < ActiveRecord::Base
    
  
  belongs_to :user
  belongs_to :place
  has_many :bill_parts
  
   validates_presence_of :name, :scope => :user_id, :message => "Za mało danych. <b>Nazwa<b/> jest wymagana."
  # validates_uniqueness_of :name,:scope => :user_id, :message => "Taki rachunek już istnieje."
  validates_length_of  :name, :maximum=>255,:message => "Za długa <b>nazwa</b>, wprowadź do <b>%d</b> znaków."
  #  validates_exclusion_of :name,:allow_nil=>true, :allow_blank=>true, :in => SPECIAL_CHARACTERS,
  #    :message => "Nie używaj znaków specjalnych."
  validates_format_of :name, :allow_nil=>true, :allow_blank=>true,
    :with => /^[A-Za-z0-9 ĄąĆćĘęŁłÓóŚśŻżŹź\-_]*\z/,
    :message => "Nie używaj znaków specjalnych."
  def removable?
    bill_parts.empty?
    #    true
  end  
  def place_name
    self.place.name if self.place
  end
  def price_summary
    sum = 0.0
    if bill_parts
      bill_parts.each do |bp|
        sum += bp.price_summary
      end
    end
    sum
  end
end
