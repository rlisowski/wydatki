class Category < ActiveRecord::Base
  belongs_to :user
  has_many :bill_parts
  validates_presence_of :name, :scope => :user_id, :message => "<b>Nazwa</b> jest wymagana."
  validates_uniqueness_of :name,:scope => :user_id, :message => "Taka <b>kategoria</b> już istnieje."
  validates_length_of  :name, :maximum=>255,:message => "Za długa <b>nazwa</b>, wprowadź do <b>%d</b> znaków."
  #  validates_exclusion_of :name,:allow_nil=>true, :allow_blank=>true, :in => SPECIAL_CHARACTERS,
  #    :message => "Nie używaj znaków specjalnych."
  validates_format_of :name, :allow_nil=>true, :allow_blank=>true,
    :with => /^[A-Za-z0-9 ĄąĆćĘęŁłÓóŚśŻżŹź\-_]*\z/,
    :message => "Nie używaj znaków specjalnych."
  def removable?
    bill_parts.empty?
  end  
end
