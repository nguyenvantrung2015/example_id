class WebauthnCredential < ApplicationRecord
  validates :external_id, presence: true, uniqueness: true
  validates :public_key, presence: true
  validates :user_id, presence: true
end
