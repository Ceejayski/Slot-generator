class CreateBookedSlots < ActiveRecord::Migration[7.0]
  def change
    create_table :booked_slots, id: :uuid do |t|
      t.date :date
      t.datetime :start_date
      t.datetime :end_date

      t.timestamps
    end
  end
end
