class CreateAds < ActiveRecord::Migration[7.0]
  def change
    create_table :ads do |t|
      t.string :headline
      t.string :body
      t.string :description
      t.integer :network
      t.jsonb :data
      t.string :cta
      t.string :url
      t.string :ad_type
      t.string :source
      t.string :launch_date
      t.string :external_library_id
      t.references :brand, null: true, foreign_key: true
      t.references :competitor, null: true, foreign_key: true

      t.timestamps
    end
  end
end
