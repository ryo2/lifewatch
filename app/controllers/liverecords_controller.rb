class LiverecordsController < ApplicationController
  # GET /liverecords
  # GET /liverecords.json
  def index

    @user = User.find(1)
    @date = params[:date].nil? ? Date.today : Date.parse(params[:date])
    @stats = Liverecord.get_stats @date
    
    @timeline = Liverecord.timeline @date

    @liverecords = @user.liverecords.all

    @ongoing_flag = @user.liverecords.where(:end => nil)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @liverecords }
    end
  end

  def create
    @user = User.find(1)
    @task = @user.tasks.find_or_create_by_name(params[:task][:name])

    @liverecord = @user.liverecords.build({
      task_id: @task.id,
      type_id: params[:liverecord][:type_id],
      start: Time.now
    })

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
    @user = User.find(1)
    @rec = @user.liverecords.where({:end => nil}).first

    if @rec.update_attributes({ :end => Time.now })
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
