class CreateResources < ActiveRecord::Migration
  def change
    create_table :resources do |t|
      t.string :name
      t.string :authors
      t.integer :type_id
      t.date :date
      t.string :url

      t.timestamps
    end
  end
end
