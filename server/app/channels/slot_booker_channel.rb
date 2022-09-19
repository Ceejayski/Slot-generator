class SlotBookerChannel < ApplicationCable::Channel
  def subscribed
    stop_all_streams
    day = params[:day] || Date.today.to_s
    p day
    stream_from "slot_booking_#{Date.parse(day)}"
  end

  def unsubscribed
    stop_all_streams
  end


end
