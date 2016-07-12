class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.timestamps
      t.text :response_uuid, limit: 36 # an UUID is 36 characters
      t.text :type
      t.json :data
    end
  end
end
