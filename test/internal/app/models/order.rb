class Order < ApplicationRecord
  before_save do |row|
    row.errors.add :base, "panic" if row.category == "error"
  end

  add_to_bag :field, flag: :boolean, at: :date
end
