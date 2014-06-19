class CreatePassages < ActiveRecord::Migration
  def change
    create_table :passages do |t|
      t.string :title
      t.text :body
      t.integer :resource_id
      t.integer :author_id

      t.timestamps
    end
  end
end
