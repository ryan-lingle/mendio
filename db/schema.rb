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

ActiveRecord::Schema.define(version: 2018_06_27_100656) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bookmarks", force: :cascade do |t|
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "episode_id"
    t.index ["episode_id"], name: "index_bookmarks_on_episode_id"
    t.index ["user_id"], name: "index_bookmarks_on_user_id"
  end

  create_table "donations", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "episode_id"
    t.bigint "influencer_id"
    t.integer "amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "description"
    t.index ["episode_id"], name: "index_donations_on_episode_id"
    t.index ["influencer_id"], name: "index_donations_on_influencer_id"
    t.index ["user_id"], name: "index_donations_on_user_id"
  end

  create_table "episodes", force: :cascade do |t|
    t.string "name"
    t.bigint "podcast_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "number"
    t.text "description"
    t.index ["podcast_id"], name: "index_episodes_on_podcast_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "bookmark_id"
    t.integer "follower_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "seen", default: false
    t.index ["bookmark_id"], name: "index_notifications_on_bookmark_id"
    t.index ["follower_id"], name: "index_notifications_on_follower_id"
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "pg_search_documents", force: :cascade do |t|
    t.text "content"
    t.string "searchable_type"
    t.bigint "searchable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["searchable_type", "searchable_id"], name: "index_pg_search_documents_on_searchable_type_and_searchable_id"
  end

  create_table "podcasts", force: :cascade do |t|
    t.string "name"
    t.bigint "creator_id"
    t.integer "balance", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "artwork"
    t.text "description"
    t.string "new_feed"
    t.index ["creator_id"], name: "index_podcasts_on_creator_id"
  end

  create_table "relationships", force: :cascade do |t|
    t.integer "follower_id"
    t.integer "followed_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["followed_id"], name: "index_relationships_on_followed_id"
    t.index ["follower_id", "followed_id"], name: "index_relationships_on_follower_id_and_followed_id", unique: true
    t.index ["follower_id"], name: "index_relationships_on_follower_id"
  end

  create_table "saves", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "donation_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["donation_id"], name: "index_saves_on_donation_id"
    t.index ["user_id"], name: "index_saves_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "profile_pic"
    t.string "username"
    t.integer "balance", default: 0, null: false
    t.string "first_name"
    t.string "last_name"
    t.string "account_id"
    t.boolean "account", default: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "views", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "donation_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["donation_id"], name: "index_views_on_donation_id"
    t.index ["user_id"], name: "index_views_on_user_id"
  end

  add_foreign_key "bookmarks", "episodes"
  add_foreign_key "bookmarks", "users"
  add_foreign_key "donations", "episodes"
  add_foreign_key "donations", "users"
  add_foreign_key "episodes", "podcasts"
  add_foreign_key "notifications", "bookmarks"
  add_foreign_key "notifications", "users"
  add_foreign_key "saves", "donations"
  add_foreign_key "saves", "users"
  add_foreign_key "views", "donations"
  add_foreign_key "views", "users"
end
