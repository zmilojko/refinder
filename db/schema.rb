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

ActiveRecord::Schema.define(version: 20141126104221) do

  create_table "car_brands", force: true do |t|
    t.string   "name"
    t.integer  "manufacturer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "car_brands", ["manufacturer_id"], name: "index_car_brands_on_manufacturer_id"

  create_table "car_brands_products", force: true do |t|
    t.integer  "product_id"
    t.integer  "car_brand_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories", force: true do |t|
    t.string   "name"
    t.integer  "parent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "url"
  end

  create_table "categories_products", force: true do |t|
    t.integer  "product_id"
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "manufacturers", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "products", force: true do |t|
    t.string   "pid"
    t.string   "name"
    t.decimal  "price"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_id"
    t.string   "shop"
    t.string   "full_categories"
    t.string   "detail_compatibility"
  end

end
