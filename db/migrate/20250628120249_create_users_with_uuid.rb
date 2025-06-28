class CreateUsersWithUuid < ActiveRecord::Migration[7.1]
  def change
    enable_extension 'pgcrypto' unless extension_enabled?('pgcrypto')

    drop_table :users, if_exists: true

    create_table :users, id: :uuid do |t|
      ## Devise fields
      t.string :encrypted_password, null: false, default: ""
      t.string :provider, null: false, default: "email"
      t.string :uid, null: false, default: ""
      t.string :reset_password_token
      t.datetime :reset_password_sent_at
      t.boolean :allow_password_change, default: false
      t.datetime :remember_created_at
      t.string :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at

      t.string :name
      t.string :nickname
      t.string :email, null: false, default: ""
      t.string :image
      t.integer :role, default: 0, null: false
      t.integer :status, default: 0, null: false

      t.json :tokens

      t.timestamps null: false
    end

    add_index :users, :email, unique: true
    add_index :users, [:uid, :provider], unique: true
    add_index :users, :reset_password_token, unique: true
    add_index :users, :confirmation_token, unique: true
    add_index :users, :status
  end
end

