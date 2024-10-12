class AddInformationToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :role, :integer, null: false, default: 1
    add_column :users, :first_name, :string, null: false
    add_column :users, :last_name, :string, null: false
  end
end
