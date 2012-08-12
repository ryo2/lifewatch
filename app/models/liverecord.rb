class Liverecord < ActiveRecord::Base
  attr_accessible :deleted_at, :end, :start, :task_id, :type_id, :user_id
  acts_as_taggable
  belongs_to :user
  belongs_to :task
  
  def self.get_timeline date, start_time = 8, end_time = 24
    timeline = Array.new
    
    0.upto(23) do |time|
      @i = 0

      self.where(:start => date..date+1).all.each do |r|
        if r.start.hour  == time
          line = {
            model: r,
            tag: r.tags[0],
            task: r.task.name,
            start: r.start.strftime("%H:%M"),
            end: r.end.strftime("%H:%M"),
            pass: self.s_to_hm(r.end - r.start)
          }
          line[:time] = time if @i == 0
          timeline << line
          @i += 1
        end
      end
      
      if time >= start_time and time <= end_time
        while @i < 2
          line = Hash.new
          line[:time] = time if @i == 0
          timeline << line
          @i += 1
        end
      end

    end
    timeline
  end
  
  def self.s_to_hm s
    hour = s/3600
    minute = (s%3600)/60
    pass = "%02d" % hour + ':' + "%02d" % minute
  end

end
