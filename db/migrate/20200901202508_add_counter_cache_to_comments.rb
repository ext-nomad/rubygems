class AddCounterCacheToComments < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :comments_count, :integer, default: 0, null: false
    add_column :lessons, :comments_count, :integer, default: 0, null: false
  end
end
