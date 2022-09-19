require 'rails_helper'

RSpec.describe AvailableTimeSlotGeneratorService do
  let(:date) { DateTime.now.to_s }
  let(:duration) { 30 }
  let(:service) { AvailableTimeSlotGeneratorService.new(date, duration) }

  describe '#get_daily_slot' do
    it 'returns all slots for a day' do
      expect(service.get_daily_slot.size).to eq(95)
    end
  end

  describe '#get_booked_slots' do
    context "if unavailable_slot is empty" do

      it 'returns all booked slots for a day' do
        expect(service.get_booked_slots).to eq([])
      end
    end

    context "if unavailable_slot is not empty" do
      let(:service) { AvailableTimeSlotGeneratorService.new(Date.today.to_s, duration) }
      let(:booked_slot) { create :booked_slot , start_date: Date.today.to_datetime, end_date: DateTime.now.beginning_of_day + 1.hour }
      subject { service.get_booked_slots }

      it 'returns all booked slots for a day' do
        booked_slot.save
        expect(subject).to eq([[booked_slot.start_date, booked_slot.end_date]])
      end

      it 'expects booked slots size to be 1' do
        booked_slot.save
        expect(subject.size).to eq(1)
      end

      it 'expects to call flatten_overlapping_slots' do
        booked_slot.save
        expect(service).to receive(:flatten_overlapping_slots)
        subject
      end

      it 'expects to call flatten_overlapping_slots with booked_slots' do
        booked_slot.save
        expect(service).to receive(:flatten_overlapping_slots).with([[booked_slot.start_date, booked_slot.end_date]])
        subject
      end

      it 'expects to call flatten_overlapping_slots once' do
        booked_slot.save
        expect(service).to receive(:flatten_overlapping_slots).once
        subject
      end
    end
  end

  describe '#flatten_overlapping_slots' do
    let(:samplearray) { [[1,4], [2,5], [6,7], [8,10], [9,11]] }
    let(:expectedarray) { [[1,5], [6,7], [8,11]] }
    subject { service.flatten_overlapping_slots(samplearray) }

    it 'returns flattened array' do
      expect(subject).to eq(expectedarray)
    end

  end

  describe '#get_available_slots' do
    let(:booked_slot) { create :booked_slot , start_date: Date.today.to_datetime, end_date: Date.today.to_datetime + 1.hour }
    subject { service.get_available_slots }

    it ' should return available slots' do
      booked_slot.save
      expect(subject).to eq([[Date.today.to_datetime + 1.hour, Date.today.end_of_day]])
    end

    it 'raise error if booked slots is empty' do
      expect { subject }.to raise_error(StandardError)
    end

  end

  describe '#get_timeframe_slots' do
    it 'returns all available timeframe slots for a day if booked slots is empty' do
      expect(service.get_timeframe_slots.size).to eq(95)
    end

    context "if booked slots is not empty" do
      let(:booked_slot) { create :booked_slot , start_date: Date.today.to_datetime + 30.minutes, end_date: Date.today.to_datetime + 1.hour }
      subject { service.get_timeframe_slots }

      it 'returns all available timeframe slots for a day' do
        booked_slot.save
        expect(subject.include?(Date.today.to_datetime + 1.hour)).to eq(false)
      end
    end

  end
end
