class User < ActiveRecord::Base
  has_many :bills
  has_many :bill_parts
  has_many :categories
  has_many :places
 
  validates_presence_of :login, :email, :password, :password_confirmation, :secure, :message => "Należy uzupełnić pola z <b>*</b>."
 
  validates_uniqueness_of :login, :email, :message => "<b>Login/mail</b> jest już wykorzystany."
  validates_confirmation_of :password, :message => "Nieprawidłowe <b>hasło</b>."
  
  #  validates_format_of :password, :with =>/^(?=.*\d)(?=.*([a-z]|[A-Z]))$/i, :message => "Nieprawidłowe <b>hasło</b>. Wymagane: co najmniej jedna cyfra, jedna litera"# plus znak specjalny ! # _ - @ $ % ^ & / \ * "
  validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i, :message => "Nieprawidłowy <b>mail</b>."
  
  validates_length_of :login, :within => 3..40, :too_short => "Za krótki <b>login</b>, min <b>3</b> zn.", :too_long => "Za długi <b>login</b>, max <b>40</b> zn."
  validates_length_of :password, :within => 8..40, :too_short => "Za krótkie <b>hasło</b>, min <b>8</b> zn.", :too_long => "Za długie <b>hasło</b>, max <b>40</b> zn."
  
  
  #  validates_exclusion_of :login,:password,:email,:forename,:surname, :allow_nil=>true, :allow_blank=>true,  :in => SPECIAL_CHARACTERS,
  #    :message => "Nie używaj znaków specjalnych."
  validates_format_of :login,:password,:forename,:surname, :allow_nil=>true, :allow_blank=>true,
    :with => /^[A-Za-z0-9]*\z/,
    :message => "Używaj tylko cyfr i liter."
  
  attr_protected :id, :secure
  
  attr_accessor :password, :password_confirmation, :old_password,:updating,:register_text
  
  
  def self.authenticate(login, pass)
    user=find(:first, :conditions=>["login = ?", login])
    return nil if user.nil?
    return user if User.encrypt(pass, user.secure)==user.hashed_password
    nil
  end  
  def save_with_my_validation
    errors.add(:forename, "Za długie imie, max 60 zn.") ; return false if self.forename.length>60
    errors.add(:surname, "Za długie nazwisko, max 60 zn.") ; return false if self.surname.length>60
    errors.add(:email, "Nieprawidłowy mail.") ; return false unless self.email=~/^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i
    self.save_with_validation(false)
  end  
  def password=(pass)
    @password=pass
    self.secure = User.random_string(10) if !self.secure?
    self.hashed_password = User.encrypt(@password, self.secure)
  end
  
  #protected
  
  def self.encrypt(pass, secure)
    Digest::SHA1.hexdigest(pass+secure)
  end
  
  def self.random_string(len)
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    newpass = ""
    1.upto(len) { |i| newpass << chars[rand(chars.size-1)] }
    return newpass
  end
end
