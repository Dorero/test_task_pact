class CreateUsersSkills < ActiveRecord::Migration[8.0]
  def change
    create_table :users_skills do |t|
      t.belongs_to :user
      t.belongs_to :skill
      t.timestamps
    end
  end
end
