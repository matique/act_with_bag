# frozen_string_literal: true

ActiveRecord::Schema.define(version: 202208) do
  create_table "orders", force: true do |t|
    t.string :category
    t.text :bag

    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: true do |t|
    t.string :type
    t.text :bag

    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end
end
