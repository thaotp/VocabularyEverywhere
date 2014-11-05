class RemoveFieldsAndAddContentToWord < ActiveRecord::Migration
  def change
  	remove_column :words, :pharse
  	remove_column :words, :mean
  	remove_column :words, :example
  	remove_column :words, :pronunciation
  	add_column :words, :content, :text
  end
end
