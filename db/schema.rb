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

ActiveRecord::Schema.define(version: 20150616203523) do

  create_table "cities", force: true do |t|
    t.string   "name"
    t.integer  "state_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "cities", ["state_id"], name: "index_cities_on_state_id"

  create_table "customers", force: true do |t|
    t.string   "name"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "headings", force: true do |t|
    t.string   "heading"
    t.integer  "keyword_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "headings", ["keyword_id"], name: "index_headings_on_keyword_id"

  create_table "industries", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "keyword_topics", force: true do |t|
    t.integer  "topic_id"
    t.integer  "keyword_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "keyword_topics", ["keyword_id"], name: "index_keyword_topics_on_keyword_id"
  add_index "keyword_topics", ["topic_id"], name: "index_keyword_topics_on_topic_id"

  create_table "keywords", force: true do |t|
    t.string   "keyword"
    t.integer  "count",      default: 500
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "meta", force: true do |t|
    t.string   "description"
    t.integer  "topic_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "meta", ["topic_id"], name: "index_meta_on_topic_id"

  create_table "page_templates", force: true do |t|
    t.integer  "template_id"
    t.integer  "page_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "page_templates", ["page_id"], name: "index_page_templates_on_page_id"
  add_index "page_templates", ["template_id"], name: "index_page_templates_on_template_id"

  create_table "pages", force: true do |t|
    t.integer  "topic_id"
    t.integer  "k1_id"
    t.integer  "k2_id"
    t.integer  "k3_id"
    t.integer  "h1_id"
    t.integer  "h2_id"
    t.integer  "h3_id"
    t.integer  "meta_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "page_title"
    t.string   "url"
    t.string   "city"
    t.string   "state"
    t.integer  "city_id"
    t.integer  "state_id"
  end

  create_table "states", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "abbrev"
  end

  create_table "templates", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status",      default: "draft"
    t.integer  "industry_id"
    t.integer  "customer_id"
  end

  add_index "templates", ["customer_id"], name: "index_templates_on_customer_id"

  create_table "topic_industries", force: true do |t|
    t.integer  "industry_id"
    t.integer  "topic_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "topic_industries", ["industry_id"], name: "index_topic_industries_on_industry_id"
  add_index "topic_industries", ["topic_id"], name: "index_topic_industries_on_topic_id"

  create_table "topics", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "first_name",             default: "", null: false
    t.string   "last_name",              default: "", null: false
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "modules_completed",      default: 0
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
