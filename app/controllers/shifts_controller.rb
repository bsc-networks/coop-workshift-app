require 'chronic'
class ShiftsController < ApplicationController
  #before_action :set_shift, only: [:show, :edit, :update, :destroy]
  skip_before_filter :set_current_user

  # GET /shifts
  # GET /shifts.json
  def index
    @shifts = Shift.all 
    @serializedShifts = json_shifts(@shifts)
    @allUsers = User.all.to_json
  end
  
  def new_timeslots
    meta_id = params[:id]
    @metashift = (Metashift.find_by_id(meta_id))
    render 'shifts/add_timeslots'
  end
  
  def add_timeslots
    shift = params[:shift]
    @metashift = Metashift.find_by_id(shift[:metashift_id])
    Shift.add_shift(shift[:dayoftheweek], shift[:start_time], shift[:end_time], @metashift)
    redirect_to '/shifts'
  end

  # GET /shifts/1
  # GET /shifts/1.json
  def show
  end

  # GET /shifts/new
  def new
    @shift = Shift.new
  end

  # GET /shifts/1/edit
  def edit
  end


  # PATCH/PUT /shifts/1
  # PATCH/PUT /shifts/1.json
  def update
    # respond_to do |format|
    #   if @shift.update(shift_params)
    #     format.html { redirect_to @shift, notice: 'Shift was successfully updated.' }
    #     format.json { render :show, status: :ok, location: @shift }
    #   else
    #     format.html { render :edit }
    #     format.json { render json: @shift.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  # DELETE /shifts/1
  # DELETE /shifts/1.json
  def destroy
    @shift = Shift.find_by_id(params[:id])
    @shift.destroy
    respond_to do |format|
      format.html { redirect_to shifts_url, notice: 'Shift was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    #def set_shift
    #  @shift = Shift.find(params[:id])
    #end

    # Never trust parameters from the scary internet, only allow the white list through.
    def shift_params
      params.require(:shift).permit(:start_time, :end_time, :metashift_id)
    end
    
    #Keys: shift, user, start_time, end_time, description
    def json_shifts(instances)
      lst = []
      instances.each do |shift|
        lst << shift.full_json
      end
      lst
    end 
end
