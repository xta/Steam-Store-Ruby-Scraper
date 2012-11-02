require_relative "databaseinfo"
class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.decimal :price
      t.integer :metascore
      t.string :name
      t.date :released

      t.timestamps
    end
  end
end
CreateGames.new.change