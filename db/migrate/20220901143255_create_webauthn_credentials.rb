class CreateWebauthnCredentials < ActiveRecord::Migration[6.0]
  def change
    create_table :webauthn_credentials do |t|
      t.string :external_id, null: false
      t.string :public_key, null: false
      t.string :user_id, null: false

      t.timestamps
    end
  end
end
