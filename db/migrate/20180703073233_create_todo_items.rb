class CreateTodoItems < ActiveRecord::Migration[5.2]
  def change
    create_table :todo_items do |t|
      t.references :user, foreign_key: true
      t.references :todo_list, foreign_key: true
      t.string :text, null: false

      t.timestamps
    end
  end
end
