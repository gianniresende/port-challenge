class CreateApiTokens < ActiveRecord::Migration[7.1]
  def change
    create_table :api_tokens do |t|
      t.string :token
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.datetime :last_used_at

      t.timestamps
    end

    add_index :api_tokens, :token, unique: true
  end
end
