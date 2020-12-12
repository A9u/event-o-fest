class CreateParticipants < ActiveRecord::Migration[6.1]
  def change
    create_table :participants do |t|
      t.bigint :user_id
      t.bigint :event_id
      t.integer :rsvp
      t.timestamps
    end
  end
end
