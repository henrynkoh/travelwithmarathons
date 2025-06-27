class CreateTravelTips < ActiveRecord::Migration[8.0]
  def change
    create_table :travel_tips do |t|
      t.string :city, null: false
      t.string :marathon
      t.text :itinerary
      t.text :case_study
      t.string :sentiment
      t.string :source_url

      t.timestamps
    end

    add_index :travel_tips, :city, unique: true
    add_index :travel_tips, :marathon
  end
end
