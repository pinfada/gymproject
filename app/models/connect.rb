class Connect < ApplicationRecord
# Sert de table de jointure entre deux utilisateurs
# Requesting When a user sends a follow request to another user (which will be accepted automatically if it is a public account)
# following When a user is following another user
# blocking When a user is blocked another user
    belongs_to :follower, class_name: "User"
    belongs_to :followed, class_name: "User"
    validates :follower_id, presence: true
    validates :followed_id, presence: true

end
