class BillPart < ActiveRecord::Base
  belongs_to :bill
  belongs_to :category
  belongs_to :user
  
  validates_numericality_of(:price, :allow_nil=>false, :message=>"<b>Cena</b> może się składać tylko z cyfr i ew. z kropki: 13.99 lub 13,99.",:greater_than=>0)
  validates_numericality_of(:count, :allow_nil=>false, :message=>"<b>Licznik</b> może się składać tylko z cyfr i ew. z kropki: 2.5 lub 2,5.",:greater_than=>0)
  
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
  
  def removable?
    true
  end  
  def category_name
    self.category.name if self.category
  end
end
