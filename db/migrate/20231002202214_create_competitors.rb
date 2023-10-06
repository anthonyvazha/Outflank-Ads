class CreateCompetitors < ActiveRecord::Migration[7.0]
  def change
    create_table :competitors do |t|
      t.string :name
      t.string :url
      t.string :ad_libary_url_facebook
      t.string :context
      t.string :logo
      t.references :brand, null: false, foreign_key: true

      t.timestamps
    end
  end
end
