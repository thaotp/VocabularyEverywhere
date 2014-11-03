class CreateWords < ActiveRecord::Migration
  def change
    create_table :words do |t|
      t.string :title
      t.string :pharse
      t.string :mean
      t.date :learn_date
      t.string :pronunciation
      t.string :example

      t.timestamps
    end
  end
end
