class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.timestamps
      t.uuid :response_uuid
      t.text :type
      t.jsonb :data
    end
  end
end
