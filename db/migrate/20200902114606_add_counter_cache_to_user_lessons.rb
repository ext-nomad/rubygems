class AddCounterCacheToUserLessons < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :user_lessons_count, :integer, default: 0, null: false
    add_column :lessons, :user_lessons_count, :integer, default: 0, null: false
  end
end
