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

ActiveRecord::Schema.define(version: 2022_01_21_143913) do

  create_table "pinger_events", force: :cascade do |t|
    t.integer "pinger_id", null: false
    t.string "reason"
    t.integer "status"
    t.float "response_time"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["pinger_id"], name: "index_pinger_events_on_pinger_id"
  end

  create_table "pingers", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.integer "interval"
    t.integer "timeout"
    t.integer "port"
    t.string "scheduler_job_id"
    t.integer "pinger_type"
    t.boolean "enabled", default: true
    t.datetime "pinged_at", precision: 6
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "pinger_events", "pingers"
end
