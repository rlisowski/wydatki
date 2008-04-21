class AddLoggedAtToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :logged_at, :timestamp
  end

  def self.down
    remove_column :users, :logged_at
  end
end
