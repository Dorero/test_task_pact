class CreateUsersInterests < ActiveRecord::Migration[8.0]
  def change
    create_table :users_interests do |t|
      t.belongs_to :user
      t.belongs_to :interest
      t.timestamps
    end
  end
end
