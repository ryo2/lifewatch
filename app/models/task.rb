class Task < ActiveRecord::Base
  attr_accessible :dead_line, :deleted_at, :estimated_duration, :importance, :name
  belongs_to :user
  has_many :liverecords
end
