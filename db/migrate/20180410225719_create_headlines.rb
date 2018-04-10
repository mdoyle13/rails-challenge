class CreateHeadlines < ActiveRecord::Migration[5.2]
  def change
    create_table :headlines do |t|
      t.integer :expert_id
      t.text :text

      t.timestamps
    end
  end
end
