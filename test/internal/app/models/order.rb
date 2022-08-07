class Order < ActiveRecord::Base
  before_save do |row|
    row.errors.add :base, "panic" if row.name == "error"
  end
end
