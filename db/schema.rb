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

ActiveRecord::Schema.define(version: 20141201102912) do

  create_table "account_to_semesters", force: true do |t|
    t.integer  "sum"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "faculty_id"
    t.integer  "type_account"
    t.string   "year"
    t.integer  "semester"
  end

  add_index "account_to_semesters", ["faculty_id"], name: "index_account_to_semesters_on_faculty_id"

  create_table "certificats", force: true do |t|
    t.string   "number"
    t.text     "who"
    t.integer  "month_start"
    t.integer  "year_start"
    t.integer  "month_finish"
    t.integer  "year_finish"
    t.date     "date_finish"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "when"
    t.integer  "student_id"
  end

  add_index "certificats", ["student_id"], name: "index_certificats_on_student_id"

  create_table "faculties", force: true do |t|
    t.string  "name"
    t.integer "old_id"
    t.string  "short_name"
  end

  create_table "groups", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "year"
    t.integer  "faculty_id"
    t.integer  "old_id"
    t.integer  "kurs"
    t.integer  "semester"
  end

  add_index "groups", ["faculty_id"], name: "index_groups_on_faculty_id"

  create_table "norms", force: true do |t|
    t.string   "name"
    t.integer  "number"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "operations", force: true do |t|
    t.integer  "sum"
    t.date     "date_op"
    t.string   "text"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "account_to_semester_id"
    t.integer  "type_op"
    t.integer  "user_id"
  end

  add_index "operations", ["account_to_semester_id"], name: "index_operations_on_account_to_semester_id"
  add_index "operations", ["user_id"], name: "index_operations_on_user_id"

  create_table "orders", force: true do |t|
    t.date     "date"
    t.text     "up"
    t.text     "signature"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "type_order"
    t.string   "number"
    t.integer  "pay_category_to_semester_id"
    t.integer  "faculty_id"
    t.string   "year"
    t.integer  "semester"
    t.string   "bottom"
    t.integer  "status"
  end

  add_index "orders", ["faculty_id"], name: "index_orders_on_faculty_id"
  add_index "orders", ["pay_category_to_semester_id"], name: "index_orders_on_pay_category_to_semester_id"

  create_table "pay_category_to_semesters", force: true do |t|
    t.date     "date_start"
    t.date     "date_finish"
    t.integer  "social"
    t.integer  "five"
    t.integer  "four"
    t.integer  "study"
    t.integer  "public"
    t.integer  "scientific"
    t.integer  "cultural"
    t.integer  "sports"
    t.integer  "social1"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "faculty_id"
    t.string   "year"
    t.integer  "semester"
    t.integer  "first"
    t.integer  "soc_five"
    t.integer  "soc_four"
  end

  add_index "pay_category_to_semesters", ["faculty_id"], name: "index_pay_category_to_semesters_on_faculty_id"

  create_table "pay_to_month_students", force: true do |t|
    t.integer  "year"
    t.integer  "month"
    t.integer  "social"
    t.integer  "academic"
    t.integer  "study"
    t.integer  "public"
    t.integer  "scientific"
    t.integer  "cultural"
    t.integer  "sports"
    t.integer  "surcharge"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "type_pay"
    t.integer  "student_id"
    t.integer  "sum"
  end

  add_index "pay_to_month_students", ["student_id"], name: "index_pay_to_month_students_on_student_id"

  create_table "roles", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "student_groups", force: true do |t|
    t.boolean  "refund"
    t.boolean  "commerce"
    t.integer  "student_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "group_id"
    t.boolean  "social"
    t.boolean  "study"
    t.boolean  "public"
    t.boolean  "scientific"
    t.boolean  "cultural"
    t.boolean  "sports"
    t.integer  "type_stipend"
    t.integer  "old_id"
  end

  add_index "student_groups", ["group_id"], name: "index_student_groups_on_group_id"
  add_index "student_groups", ["student_id"], name: "index_student_groups_on_student_id"

  create_table "students", force: true do |t|
    t.string   "firstname"
    t.string   "surname"
    t.string   "secondname"
    t.text     "text"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "old_id"
    t.string   "surname_dp"
    t.string   "surname_rp"
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest"
    t.string   "remember_token"
    t.integer  "faculty_id"
    t.string   "tel"
  end

  add_index "users", ["faculty_id"], name: "index_users_on_faculty_id"
  add_index "users", ["remember_token"], name: "index_users_on_remember_token"

  create_table "users_roles", force: true do |t|
    t.integer  "user_id"
    t.integer  "role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users_roles", ["role_id"], name: "index_users_roles_on_role_id"
  add_index "users_roles", ["user_id"], name: "index_users_roles_on_user_id"

end
