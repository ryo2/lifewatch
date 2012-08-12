class DailyRecord < ActiveRecord::Base
  attr_accessible :date, :deleted_at, :norm, :tyoe4, :type1, :type2, :type3, :type5, :type6, :user_id
  belongs_to :user
end
