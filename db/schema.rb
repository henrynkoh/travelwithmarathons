# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_06_27_131858) do
  create_table "travel_tips", force: :cascade do |t|
    t.string "city", null: false
    t.string "marathon"
    t.text "itinerary"
    t.text "case_study"
    t.string "sentiment"
    t.string "source_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["city"], name: "index_travel_tips_on_city", unique: true
    t.index ["marathon"], name: "index_travel_tips_on_marathon"
  end

  create_table "videos", force: :cascade do |t|
    t.integer "travel_tip_id", null: false
    t.string "script", null: false
    t.string "video_path"
    t.string "thumbnail_path"
    t.string "youtube_id"
    t.string "status", default: "pending", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["status"], name: "index_videos_on_status"
    t.index ["travel_tip_id"], name: "index_videos_on_travel_tip_id"
    t.index ["youtube_id"], name: "index_videos_on_youtube_id", unique: true
  end

  add_foreign_key "videos", "travel_tips"
end
