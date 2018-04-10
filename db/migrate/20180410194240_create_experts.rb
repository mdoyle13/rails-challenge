class CreateExperts < ActiveRecord::Migration[5.2]
  def change
    create_table :experts do |t|
      t.string :name
      t.text :url
      t.text :short_url

      t.timestamps
    end
  end
end
