class Post < ApplicationRecord
  has_many :replies, class_name: 'Post', foreign_key: :thread_id
  scope :not_reply, -> { where(thread_id: nil) }
  belongs_to :user
  belongs_to :postable, polymorphic: true
  belongs_to :thread, class_name: "Post", optional: true
  #has_many :replies, class_name: "Post", foreign_key: :thread_id
end
