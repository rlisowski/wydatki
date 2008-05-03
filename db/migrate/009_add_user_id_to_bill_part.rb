class AddUserIdToBillPart < ActiveRecord::Migration
  def self.up
    add_column :bill_parts, :user_id, :int
  end

  def self.down
    remove_column :bill_parts, :user_id
  end
end
