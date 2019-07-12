# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_06_06_201418) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "albums", force: :cascade do |t|
    t.string "name"
    t.text "cover_photo_data"
  end

  create_table "photos", force: :cascade do |t|
    t.bigint "album_id"
    t.string "title"
    t.text "image_data"
    t.text "video_data"
    t.index ["album_id"], name: "index_photos_on_album_id"
  end

  create_table "videos", force: :cascade do |t|
    t.bigint "album_id"
    t.string "title"
    t.text "video_data"
    t.index ["album_id"], name: "index_videos_on_album_id"
  end

  add_foreign_key "photos", "albums"
  add_foreign_key "videos", "albums"
end
