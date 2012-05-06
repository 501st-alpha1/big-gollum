class Wiki < ActiveRecord::Base
  attr_accessible :name

  validates_format_of :name, :with => /\A(\w|-|_)*\Z/
  validates_uniqueness_of :name

  def to_s
     name
  end
end