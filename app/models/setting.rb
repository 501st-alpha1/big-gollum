class Setting < ActiveRecord::Base
  validates_presence_of :value

  def self.value_for(key)
    Setting.find_or_initialize_by(key: key).value || "Big Gollum"
  end
end