class Liverecord < ActiveRecord::Base
  attr_accessible :deleted_at, :end, :start, :task_id, :type_id, :user_id
  acts_as_taggable
  belongs_to :user
  belongs_to :task

  def self.timeline date, start_hour = 8, end_hour = 24
    #initialize
    timeline = {}
    start_hour.upto(end_hour) do |hour|
      timeline[hour] = []
    end
    #insert real data
    self.where(:start => date..(date + 1.day)).each do |l|
      timeline[l.start.hour] << l
    end
    #insert dummy data
    start_hour.upto(end_hour) do |hour|
      timeline[hour].count.upto(1) do
        timeline[hour] << self.new
      end
    end

    timeline # Hash: key is hour, value is array of liverecords
  end

  def pass
    return if !self.start || !self.end
    hour = (self.end - self.start) / 3600
    minute = ((self.end - self.start) % 3600) / 60
    "#{'%02d' % hour}:#{'%02d' % minute}"
  end
end
