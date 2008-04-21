class Place < ActiveRecord::Base
  belongs_to :user
  has_many :bills
  validates_presence_of :name, :scope => :user_id, :message => "<b>Nazwa</b> jest wymagana."
  validates_presence_of :full_name, :scope => :user_id, :message => "<b>Pełna nazwa</b> jest wymagana."
  validates_uniqueness_of :name, :scope => :user_id, :message => "Już użyto takiej <b>nazwy</b>."
  validates_uniqueness_of :full_name, :scope => :user_id, :message => "Już użyto takiej <b>pełnej nazwy</b>."
  validates_length_of  :name, :maximum=>255,:message => "Za długa <b>nazwa</b>, wprowadź do <b>%d</b> znaków."
  validates_length_of  :full_name , :maximum=>255,:message => "Za długa <b>pełna nazwa</b>, wprowadź do <b>%d</b> znaków."
  validates_length_of  :street , :maximum=>255,:message => "Za długa <b>ulica</b>, wprowadź do <b>%d</b> znaków."
  validates_length_of  :city , :maximum=>255,:message => "Za długie <b>miasto</b>, wprowadź do <b>%d</b> znaków."
  #  validates_exclusion_of :name,:full_name,:street,:city, :allow_nil=>true, :allow_blank=>true, :in => SPECIAL_CHARACTERS,:message => "Nie używaj znaków specjalnych."
  validates_format_of :name,:full_name,:street,:city, :allow_nil=>true, :allow_blank=>true,
    :with => /^[A-Za-z0-9 ĄąĆćĘęŁłÓóŚśŻżŹź\-_]*\z/,
    :message => "Nie używaj znaków specjalnych."
  def removable?
    bills.empty?
  end  
end
