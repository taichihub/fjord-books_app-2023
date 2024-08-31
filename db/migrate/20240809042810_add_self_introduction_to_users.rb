class AddSelfIntroductionToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :self_introduction, :string, limit: 200
  end
end
