class CreateVideos < ActiveRecord::Migration[8.0]
  def change
    create_table :videos do |t|
      t.references :travel_tip, null: false, foreign_key: true, index: true
      t.string :script, null: false
      t.string :video_path
      t.string :thumbnail_path
      t.string :youtube_id
      t.string :status, null: false, default: 'pending'

      t.timestamps
    end

    add_index :videos, :youtube_id, unique: true
    add_index :videos, :status
  end
end
