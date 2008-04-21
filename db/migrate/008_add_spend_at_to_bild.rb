class AddSpendAtToBild < ActiveRecord::Migration
  def self.up
    add_column :bills, :spend_at, :timestamp
  end

  def self.down
    remove_column :bills, :spend_at
  end
end
