class User < ActiveRecord::Base
  attr_accessible :default_norm, :deleted_at, :is_verified, :name, :password
  has_many :tasks
  has_many :liverecords
  has_many :daily_records
  acts_as_tagger
end
