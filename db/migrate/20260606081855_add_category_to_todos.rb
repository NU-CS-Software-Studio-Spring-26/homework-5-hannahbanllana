class AddCategoryToTodos < ActiveRecord::Migration[8.1]
  def change
    add_column :todos, :category, :string
  end
end
