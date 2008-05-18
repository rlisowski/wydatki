class BillPart < ActiveRecord::Base
  belongs_to :bill
  belongs_to :category
  belongs_to :user
  
  
  before_save :update_price_summary
  after_save :update_bill
  after_update :update_bill
  after_destroy :update_bill
  
 
  validates_numericality_of(:price, :allow_nil=>false, :message=>"<b>Cena</b> może się składać tylko z cyfr i ew. z kropki: 13.99.",:greater_than=>0)
  validates_numericality_of(:count, :allow_nil=>false, :message=>"<b>Licznik</b> może się składać tylko z cyfr i ew. z kropki: 2.5.",:greater_than=>0)
  
  #  validates_format_of :count, :allow_nil=>false, :allow_blank=>false,
  #    :with => /^(\d[\d_]*)[\.,][\d]*$/,
  #    :message => "<b>Licznik</b> może się składać tylko z cyfr i ew. z kropki."
  
  validates_presence_of :name, :message => "<b>Nazwa</b> jest wymagana."
  validates_length_of  :name, :maximum=>255,:message => "Za długa <b>nazwa</b>, wprowadź do %d znaków."
  #  validates_exclusion_of :name,:allow_nil=>true, :allow_blank=>true, :in => SPECIAL_CHARACTERS,
  #    :message => "Nie używaj znaków specjalnych."
  validates_format_of :name, :allow_nil=>true, :allow_blank=>true,
    :with => /^[A-Za-z0-9 ĄąĆćĘęŁłÓóŚśŻżŹź\-_]*\z/,
    :message => "Nie używaj znaków specjalnych."
  
  
  
  def update_bill
    bill.update_price_summary
  end
  
  def removable?
    true
  end  
  
  def category_name
    self.category.name if self.category
  end

  def update_price_summary
    self.price = round_to_f(self.price)
    self.count = round_to_f(self.count)
    self.price_summary = round_to_f( self.price * self.count )
  end
end
