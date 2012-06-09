class CreateUsersWikis < ActiveRecord::Migration
  def change
    create_table :users_wikis do |t|
      t.references :wiki
      t.references :user
    end
  end
end
