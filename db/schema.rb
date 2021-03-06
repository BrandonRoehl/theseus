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

ActiveRecord::Schema.define(version: 20170816172425) do

  create_table "instances", id: false, force: :cascade do |t|
    t.string "key", null: false
    t.text "value"
    t.integer "model_id", null: false
    t.index ["key", "model_id"], name: "index_instances_on_key_and_model_id", unique: true
    t.index ["model_id"], name: "index_instances_on_model_id"
  end

  create_table "models", force: :cascade do |t|
    t.string "name"
    t.index ["name"], name: "index_models_on_name", unique: true
  end

end
