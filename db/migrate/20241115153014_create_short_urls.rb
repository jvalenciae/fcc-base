class CreateShortUrls < ActiveRecord::Migration[7.0]
  def change
    create_table :short_urls do |t|
      t.string :original_url
      t.string :shortened_url
      t.integer :visits, default: 0
      t.string :title

      t.timestamps
    end
  end
end
