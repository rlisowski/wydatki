class CreateBillParts < ActiveRecord::Migration
  def self.up
    create_table :bill_parts do |t|
      t.string :name
      t.float :price
      t.float :price_summary
      t.float :count
      t.references :bill, :category
      t.timestamps
    end
  end

  def self.down
    drop_table :bill_parts
  end
end
