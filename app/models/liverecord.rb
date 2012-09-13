class Liverecord < ActiveRecord::Base
#カラム名
  attr_accessible :deleted_at, :end, :start, :task_id, :type_id, :user_id
  acts_as_taggable
  belongs_to :user
  belongs_to :task
  validates :type_id, :presence => true, :on => :create  
  validates :task_id, :presence => {:message => 'You should fill your taskname.'}, :on => :create  
  validates :start, :presence => true, :on => :create  
  
  def self.timeline date, start_hour = 8, end_hour = 24
    #initialize
    timeline = {}
    0.upto(24) do |hour|
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

  
  def self.s_to_hm s
    hour = s/3600
    min = (s%3600)/60
    pass = "%02d" % hour + ':' + "%02d" % min
  end
  
  def self.get_stats date
    stats = {
      :slept => { today: 0, yesterday: 0},
      :value => { today: 0, yesterday: 0},
      :relax => { today: 0, yesterday: 0},
      :live => { today: 0, yesterday: 0},
      :unknown => { today: 86400, yesterday: 86400}
    }
    
    self.where(:start => date-1..date+1).all.each do |r|
      pass = r.end ? r.end - r.start : 0
      
      if r.start.day == date.day
        case r.type_id
        when 1, 2
          stats[:value][:today] += pass
        when 3, 4
          stats[:relax][:today] += pass
        when 5
          stats[:live][:today] += pass
        when 6
          stats[:slept][:today] += pass
        end
        stats[:unknown][:today] -= pass
      else
        case r.type_id
        when 1, 2
          stats[:value][:yesterday] += pass
        when 3, 4
          stats[:relax][:yesterday] += pass
        when 5
          stats[:live][:yesterday] += pass
        when 6
          stats[:slept][:yesterday] += pass
        end
        stats[:unknown][:yesterday] -= pass
      end
    end
    stats = self.format_stats stats
  end

  def self.format_stats stats
    stats.each do |k, v|
      stats[k][:diff] = self.s_to_hm(v[:today] - v[:yesterday])
      stats[k][:diffclass] = v[:today] - v[:yesterday] < 0 ? 'redChar' : 'blueChar'
      stats[k][:rate] = (v[:today]/86400 * 100).round(0).to_s + "%"
      stats[k][:today] = self.s_to_hm(stats[k][:today])
    end
    stats
  end

  def pass
    return if !self.start || !self.end
    hour = (self.end - self.start) / 3600
    minute = ((self.end - self.start) % 3600) / 60
    "#{'%02d' % hour}:#{'%02d' % minute}"
  end
  
  private
    def duplication_check
      self.where(:end => nil).exists?
      @error = "Going task already exists."
    end

end