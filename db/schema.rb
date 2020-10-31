# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_10_31_170610) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "brainstorms", force: :cascade do |t|
    t.text "problem"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "token"
  end

  create_table "idea_builds", force: :cascade do |t|
    t.string "idea_build_text"
    t.bigint "idea_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["idea_id"], name: "index_idea_builds_on_idea_id"
  end

  create_table "ideas", force: :cascade do |t|
    t.string "text"
    t.bigint "brainstorm_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "likes", default: 0
    t.index ["brainstorm_id"], name: "index_ideas_on_brainstorm_id"
  end

end
