class CreateTodoLists < ActiveRecord::Migration[5.2]
  def change
    create_table :todo_lists do |t|
      t.references :user, foreign_key: true
      t.references :campaign, foreign_key: true

      t.string :name, null: false

      t.timestamps
    end
  end
end
