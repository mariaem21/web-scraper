# frozen_string_literal: true

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

ActiveRecord::Schema[7.0].define(version: 20_230_220_184_715) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'

  create_table 'appcats', id: false, force: :cascade do |t|
    t.integer 'appcatID', primary_key: true
    t.integer 'categoryID', foreign_key: true
    t.integer 'applicationID', foreign_key: true
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'applications', id: false, force: :cascade do |t|
    t.integer 'applicationID', primary_key: true
    t.integer 'orgID', foreign_key: true
    t.string 'name'
    t.date 'datebuilt'
    t.string 'githublink'
    t.string 'description'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'categories', id: false, force: :cascade do |t|
    t.integer 'categoryID', primary_key: true
    t.string 'name'
    t.string 'description'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'contacts', id: false, force: :cascade do |t|
    t.integer 'personID', primary_key: true
    t.integer 'orgID', foreign_key: true
    t.date 'year'
    t.string 'name'
    t.string 'email'
    t.string 'officerposition'
    t.string 'description'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'organizations', id: false, force: :cascade do |t|
    t.integer 'orgID', primary_key: true
    t.string 'name'
    t.string 'description'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'users', id: false, force: :cascade do |t|
    t.integer 'userID', primary_key: true
    t.string 'name'
    t.string 'username'
    t.string 'password'
    t.boolean 'isadmin'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end
end
