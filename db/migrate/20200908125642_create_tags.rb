class CreateTags < ActiveRecord::Migration[6.0]
  def change
    create_table :tags do |t|
      t.string :name
      t.integer :course_tags_count, default: 0, null: false
    end
  end
end
