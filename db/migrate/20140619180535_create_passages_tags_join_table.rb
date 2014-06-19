class CreatePassagesTagsJoinTable < ActiveRecord::Migration
  def change
    create_join_table :passages, :tags do |t|
      # t.index [:passage_id, :tag_id]
      t.index [:tag_id, :passage_id], unique: true
    end
  end
end
