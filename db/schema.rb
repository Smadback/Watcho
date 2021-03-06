# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20140611073319) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "entries", force: true do |t|
    t.string   "title"
    t.integer  "lastepisode"
    t.integer  "lastseason"
    t.string   "releaseday"
    t.integer  "user_id",     null: false
    t.string   "link"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "key"
  end

  create_table "episodes", force: true do |t|
    t.integer  "season_id"
    t.integer  "number",     null: false
    t.date     "starts_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "news", force: true do |t|
    t.string   "title"
    t.text     "text"
    t.integer  "user_id",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "seasons", force: true do |t|
    t.integer "show_id"
    t.integer "number",  null: false
  end

  create_table "shows", force: true do |t|
    t.string   "title",      null: false
    t.string   "airday"
    t.string   "airtime"
    t.string   "timezone"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_shows", force: true do |t|
    t.integer  "user_id",                        null: false
    t.integer  "show_id",                        null: false
    t.integer  "lastseason",         default: 0
    t.integer  "lastepisode",        default: 0
    t.string   "link"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "episodes_available", default: 0
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "role"
  end

end
