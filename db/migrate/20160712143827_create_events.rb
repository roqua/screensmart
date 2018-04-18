class CreateEvents < ActiveRecord::Migration[4.2]
  def change
    create_table :events do |t|
      t.timestamps
      t.uuid :response_uuid
      t.text :type
      t.jsonb :data
    end
  end
end
