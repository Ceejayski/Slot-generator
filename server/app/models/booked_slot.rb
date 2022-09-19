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
class BookedSlot < ApplicationRecord
  # Callbacks
  before_save :set_date
  # Associations

  # Validations
  validates_presence_of :start_date, :end_date
  validate :start_date_before_end_date
  validates :start_date, :end_date, :overlap => {:message_title => "Slot unavailable", :message_content => "Slot taken"}

  # Validation methods
  def start_date_before_end_date
    return if start_date.blank? || end_date.blank?
    if start_date > end_date
      errors.add(:start_date, "must be before end date")
    end
  end

  # Scopes and Object methods

  def set_date
    self.date = start_date.to_date
  end
end
