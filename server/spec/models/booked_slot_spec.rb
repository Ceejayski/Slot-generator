# == Schema Information
#
# Table name: booked_slots
#
#  id         :uuid             not null, primary key
#  date       :date
#  start_date :datetime
#  end_date   :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe BookedSlot, type: :model do
  let(:booked_slot) { build(:booked_slot) }
  let(:booked_slot2) { build(:booked_slot, end_date: "2022-09-17 00:55:00.000000000 +0000") }
  let(:booked_slot3) { build(:booked_slot, start_date: "2022-09-17 00:50:00.000000000 +0000", end_date: "2022-09-17 01:55:00.000000000 +0000") }

  describe "validations" do
    it { should validate_presence_of(:start_date) }
    it { should validate_presence_of(:end_date) }
    it 'should validate start_date before end_date' do
      booked_slot.start_date = Time.now
      booked_slot.end_date = Time.now - 1.day
      expect(booked_slot).to_not be_valid
      expect(booked_slot.errors.full_messages).to include("Start date must be before end date")
    end
    it 'should validate available dates' do
      booked_slot.save
      expect(booked_slot2).to_not be_valid
      expect(booked_slot2.errors.full_messages).to include("Slot unavailable Slot taken")
    end

    it 'should validate available dates' do
      booked_slot.save
      expect(booked_slot3).to be_valid
    end

  end


end
