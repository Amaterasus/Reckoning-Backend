class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :username
      t.string :password_digest
      t.string :email
      t.date :dob
      t.bigint :steamID64
      t.string :bio
      t.boolean :admin, :default => false

      t.timestamps
    end
  end
end
