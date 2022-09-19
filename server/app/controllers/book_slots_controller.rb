class BookSlotsController < ApplicationController

  # GET /book_slots
  # params: day: date,
  #         duration: integer
  # response: available_slots: array
  def query
    # Get the day and duration from params
    day = params[:day] || Date.today.to_s
    duration = params[:duration] || "30"
    # Get all the available slots for the day
    available_slots = AvailableTimeSlotGeneratorService.new(day, duration.to_i).get_timeframe_slots
    # Return the available slots
    render json: { available_slots: available_slots, error: false }
  end


  # POST /book_slots
  # params:
  #         duration: integer,
  #         slot: datetime
  # response: message: string

  def create
    selected_slot = convert_to_utc(book_slot_params[:slot])
    available_slots = AvailableTimeSlotGeneratorService.new(selected_slot.to_date.to_s, book_slot_params[:duration]).get_timeframe_slots
    raise 'Invalid/ Unavailable slot' unless available_slots.include?(selected_slot)
    end_date = selected_slot.advance(minutes: book_slot_params[:duration].to_i)
    BookedSlot.create!(start_date: selected_slot, end_date: end_date)
    ActionCable.server.broadcast "slot_booking_#{Date.parse(selected_slot.to_date.to_s)}", { slot: selected_slot, message: "Slot #{selected_slot.strftime( "%B, %d %Y, %H:%m" )} has been booked by #{book_slot_params[:name]}", error: false }.as_json
    render json: { message: 'Slot booked successfully', error: false }, status: :created
  rescue => e

    render json: { error_message: e.message, error: true }, status: :unprocessable_entity
  end

  private

  # Convert the datetime to UTC
  def convert_to_utc(time)
    DateTime.parse(time).utc
  end

  def book_slot_params
    params.require(:book_slot).permit( :duration, :slot, :name)
  end
end
