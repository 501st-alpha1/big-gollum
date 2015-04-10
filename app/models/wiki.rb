class Wiki < ActiveRecord::Base

  has_and_belongs_to_many :users

  validates_format_of :name, :with => /\A(\w|-|_)*\Z/
  validates_uniqueness_of :name

  def to_s
     name
  end

  def add_member(user)
    self.users << user
    self.save
  end
end