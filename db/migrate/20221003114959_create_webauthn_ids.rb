class CreateWebauthnIds < ActiveRecord::Migration[6.0]
  def change
    create_table :webauthn_ids do |t|
      t.references :user, null: false, foreign_key: true
      t.string :webauthn_id

      t.timestamps
    end
  end
end
