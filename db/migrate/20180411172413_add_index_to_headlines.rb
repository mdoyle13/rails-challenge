class AddIndexToHeadlines < ActiveRecord::Migration[5.2]
  def change
    add_index :headlines, :expert_id
  end
end
