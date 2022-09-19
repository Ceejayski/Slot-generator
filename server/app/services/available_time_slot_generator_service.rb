class AvailableTimeSlotGeneratorService
  attr_reader :date, :duration, :unavailable_slots

  INTERVAL = ENV['SLOT_INTERVAL'].nil? ? 15 : ENV['SLOT_INTERVAL'].to_i

  def initialize(date, duration)
    @date = Date.parse(date)
    @duration = duration
    @unavailable_slots = BookedSlot.where(date:).order(start_date: :asc, end_date: :asc).pluck(:start_date,
      :end_date)
  end

  def call
  end

  def get_daily_slot
    start_time = @date.beginning_of_day
    end_time = @date.end_of_day
    slots = []

    while start_time.send(:<=, end_time)
      slots << start_time
      start_time = start_time.advance(minutes: INTERVAL)
    end

    remainder = (duration.to_f / INTERVAL).ceil
    slots[0..-remainder]
  end

  # get unavailable/booked slots
  def get_booked_slots
    booked_slots = find_unavailable_slot(date)

    day_before_booked_slot = find_unavailable_slot(date.yesterday)

    next_day_booked_slot = find_unavailable_slot(date.tomorrow)

    if day_before_booked_slot.last
      booked_slots = [day_before_booked_slot.last].concat(booked_slots)
    end

    if next_day_booked_slot.first
      booked_slots << next_day_booked_slot.first
    end

    booked_slots.empty? ? [] : flatten_overlapping_slots(booked_slots)
  end

  # Flatten/Merge overlapping slots
  def flatten_overlapping_slots(booked_slots)
    flattened = [booked_slots[0]]
    booked_slots[1..booked_slots.size].each do |current_slot|
      previous_slot = flattened.last
      current_start, current_end = current_slot
      previous_start, previous_end = previous_slot
      if previous_end >= current_start
        flattened[-1] = [previous_start, [current_end, previous_end].max]
      else
        flattened << current_slot
      end
    end
    flattened
  end

  # get available slots
  def get_available_slots
    booked_slots = get_booked_slots
    find_available_slot(booked_slots)
  end

  def get_timeframe_slots
    interval = INTERVAL
    timeframe_slots = []

    return get_daily_slot if get_booked_slots.empty?

    available_slots = get_available_slots
    if available_slots[0].present? && (available_slots[0][0] == date.to_datetime)
      timeframe_slots = [date.beginning_of_day]
    end

    available_slots.each do |slots|
      start_time = slots[0]
      end_time = slots[1]
      no_of_intervals = (((end_time - start_time) - duration.minutes.to_i) / (interval.minutes.to_i * 2)).to_i
      no_of_intervals.times do
        start_time = start_time.advance(minutes: interval)
        next if start_time.to_date != date

        timeframe_slots << start_time
      end
    end
    timeframe_slots
  end

  private

    def find_available_slot(booked_slots)
      available_slots = []
      if booked_slots[0] && booked_slots[0][0] - date.to_datetime >= (duration.minutes + 15.minutes)
        available_slots[0] = [date.to_datetime.beginning_of_day, booked_slots[0][0]]
      elsif booked_slots.size == 1 && booked_slots[0][0] - date.to_datetime < duration.minutes
        available_slots[0] = [booked_slots[0][1], date.to_date.end_of_day]
      end

      (1..booked_slots.size - 1).each do |index|
        start = booked_slots[index - 1][1]
        finish = booked_slots[index][0]

        available_slots << [start, finish] if (finish - start) >= (duration.minutes + (INTERVAL.minutes * 2))
      end

      if (available_slots.last.nil? || (available_slots.last[1] < date.to_datetime.end_of_day)) && (date.to_datetime.end_of_day.to_i - booked_slots.last[1].to_i >= duration.minutes)

        available_slots << [booked_slots.last[1], date.to_date.end_of_day]
      end
      available_slots
    end

    def find_unavailable_slot(day)
      BookedSlot.where('DATE(start_date) = ? OR DATE(end_date) = ? ', day, day).order(start_date: :asc, end_date: :asc).pluck(
        :start_date, :end_date
      )
    end
end
