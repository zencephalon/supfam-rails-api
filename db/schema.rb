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

ActiveRecord::Schema.define(version: 2020_07_13_145011) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "conversation_memberships", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "conversation_id"
    t.integer "type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "profile_id"
    t.bigint "last_read_message_id"
    t.index ["conversation_id"], name: "index_conversation_memberships_on_conversation_id"
    t.index ["last_read_message_id"], name: "index_conversation_memberships_on_last_read_message_id"
    t.index ["profile_id"], name: "index_conversation_memberships_on_profile_id"
    t.index ["user_id"], name: "index_conversation_memberships_on_user_id"
  end

  create_table "conversations", force: :cascade do |t|
    t.string "dmId"
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "last_message_id"
    t.integer "message_count"
    t.bigint "last_message_profile_id"
    t.index ["last_message_profile_id"], name: "index_conversations_on_last_message_profile_id"
  end

  create_table "families", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "families_users", id: false, force: :cascade do |t|
    t.bigint "family_id", null: false
    t.bigint "user_id", null: false
    t.index ["family_id"], name: "index_families_users_on_family_id"
    t.index ["user_id"], name: "index_families_users_on_user_id"
  end

  create_table "friend_invites", force: :cascade do |t|
    t.bigint "from_profile_id"
    t.bigint "to_profile_id"
    t.integer "status", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["from_profile_id"], name: "index_friend_invites_on_from_profile_id"
    t.index ["to_profile_id"], name: "index_friend_invites_on_to_profile_id"
  end

  create_table "friendships", force: :cascade do |t|
    t.bigint "from_profile_id"
    t.bigint "to_profile_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "to_user_id"
    t.bigint "from_user_id"
    t.index ["from_profile_id"], name: "index_friendships_on_from_profile_id"
    t.index ["from_user_id"], name: "index_friendships_on_from_user_id"
    t.index ["to_profile_id"], name: "index_friendships_on_to_profile_id"
    t.index ["to_user_id"], name: "index_friendships_on_to_user_id"
  end

  create_table "invitations", force: :cascade do |t|
    t.bigint "from_profile_id"
    t.integer "status", default: 0
    t.string "phone", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["from_profile_id"], name: "index_invitations_on_from_profile_id"
  end

  create_table "messages", force: :cascade do |t|
    t.bigint "conversation_id"
    t.integer "type"
    t.string "message"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "profile_id"
    t.float "qid"
    t.jsonb "links"
    t.index ["conversation_id"], name: "index_messages_on_conversation_id"
    t.index ["profile_id"], name: "index_messages_on_profile_id"
  end

  create_table "phone_verifications", force: :cascade do |t|
    t.string "token"
    t.string "phone"
    t.string "code"
    t.boolean "verified"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "profiles", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "name"
    t.jsonb "status"
    t.jsonb "location"
    t.jsonb "seen"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "is_default"
    t.string "avatar_key"
    t.string "short_desc"
    t.index ["user_id"], name: "index_profiles_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "phone"
    t.string "name"
    t.string "password_digest"
    t.string "api_key"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "push_token"
    t.index ["name"], name: "index_users_on_name", unique: true
    t.index ["phone"], name: "index_users_on_phone", unique: true
  end

  add_foreign_key "profiles", "users"
end
