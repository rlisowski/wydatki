class CreatePlaces < ActiveRecord::Migration
  def self.up
    create_table :places do |t|
      t.string :name
      t.string :full_name
      t.string :street
      t.string :city
      t.references :user
      t.timestamps
    end
  end

  def self.down
    drop_table :places
  end
end
