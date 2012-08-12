class LiverecordsController < ApplicationController
  # GET /liverecords
  # GET /liverecords.json
  def index
    @date = params[:date].nil? ? Date.today : Date.parse(params[:date])

    @timeline = Liverecord.get_timeline @date
    
    @liverecords = Liverecord.all

    @ongoing_flag = Liverecord.where(:end => nil).exists?
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @liverecords }
    end
  end

  def create
    @user = User.find(1)

    @task = Task.find_or_create_by_name(params[:task][:name])
    record = {
      user_id: @user.id,
      task_id: @task.id,
      type_id: params[:liverecord][:type_id],
      start: Time.now
    }

    @liverecord = Liverecord.new(record)

    if @liverecord.save
      @user.tag(@liverecord, :with => params[:tag][:name], :on => :tags)
      redirect_to :root, :flash => {:notice => "Your new task started!"}
    else
      redirect_to :root, :flash => {:error => "Failed to save the record."}
    end
  end

  # GET /liverecords/1
  # GET /liverecords/1.json
  def show
    @liverecord = Liverecord.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @liverecord }
    end
  end

  def stop
    @rec = Liverecord.where({:user_id => 1, :end => nil}).first
    @rec.end = Time.now
    if @rec.save
      redirect_to :root, :flash => {:notice => "Stop the task!"}
    else
      redirect_to :root, :flash => {:error => "Something failed."}
    end
  end


  # GET /liverecords/new
  # GET /liverecords/new.json
  def new
    @liverecord = Liverecord.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @liverecord }
    end
  end

  # GET /liverecords/1/edit
  def edit
    @liverecord = Liverecord.find(params[:id])
  end

  # PUT /liverecords/1
  # PUT /liverecords/1.json
  def update
    @liverecord = Liverecord.find(params[:id])

    respond_to do |format|
      if @liverecord.update_attributes(params[:liverecord])
        format.html { redirect_to @liverecord, notice: 'Liverecord was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @liverecord.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /liverecords/1
  # DELETE /liverecords/1.json
  def destroy
    @liverecord = Liverecord.find(params[:id])
    @liverecord.destroy

    respond_to do |format|
      format.html { redirect_to liverecords_url }
      format.json { head :no_content }
    end
  end
end
