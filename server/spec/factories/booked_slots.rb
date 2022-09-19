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
FactoryBot.define do
  factory :booked_slot do
    date { "2022-09-17" }
    start_date { "2022-09-17 00:00:00" }
    end_date { "2022-09-17 00:45:00" }
  end
end
