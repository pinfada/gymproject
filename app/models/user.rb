class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
    devise :database_authenticatable, :registerable,
            :recoverable, :rememberable, :validatable
    has_many :posts, as: :postable
    has_many :connects
    has_many :gymhouse_customer, class_name:  "Gymhouse", dependent: :destroy,
                                foreign_key: "customer_id"
    has_many :gymhouse_prospect,  class_name:  "Gymhouse", dependent: :destroy,
                                foreign_key: "prospect_id"

    has_many :connects, foreign_key: "follower_id", dependent: :destroy
    has_many :followed_users, through: :connects, source: :followed
    has_many :reverse_connects, foreign_key: "followed_id",
                                      class_name:  "Connect",
                                      dependent:   :destroy
    has_many :followers, through: :reverse_connects, source: :follower

    #has_many :friends, through: :connects
    #has_many :inward_connects, class_name: "Connect", foreign_key: :friend_id
    has_many :reservations, dependent: :destroy
    has_many :reserved_gymhouses, through: :reservations, source: :gymhouse
    has_one :profile, dependent: :destroy

    #has_many :followings,
    #-> { Connect.following },
    #through: :Connects,
    #source: :friend

    #has_many :follow_requests,
    #-> { Connect.requesting },
    #through: :Connects,
    #source: :friend

    #has_many :followers,
    #-> { Connect.following },
    #through: :inward_connects,
    #source: :user

    validates :first_name, presence: true, length: { maximum: 50 }, on: :create 
    validates :last_name, presence: true, length: { maximum: 50 }, on: :update 
    validates :username, presence: true, length: { maximum: 50 } 
    validates :email, presence: true, 
            format: { with: URI::MailTo::EMAIL_REGEXP, message: "must be a valid email address"}, uniqueness: { case_sensitive: false }

    before_save :ensure_proper_name_case
    before_save :default_public_value
    before_save { self.email = email.downcase }

    after_create :create_profile
    def create_profile
      self.profile = Profile.new
      save!
    end

    delegate :first_name, :last_name, :username, to: :profile, prefix: true

    def gravatar_url
        hash = Digest::MD5.hexdigest(email)
        "https://www.gravatar.com/avatar/#{hash}?d=wavatar"
    end

    enum role: [:prospect, :customer, :admin, :moderator]
    after_initialize :set_default_role, :if => :new_record?
    def set_default_role
      self.role ||= :prospect
    end

    def following?(other_user)
      connects.find_by(followed_id: other_user.id)
    end
  
    def follow!(other_user)
      connects.create!(followed_id: other_user.id)
    end
  
    def unfollow!(other_user)
      connects.find_by(followed_id: other_user.id).destroy
    end

    private
        def ensure_proper_name_case
            self.first_name = first_name.capitalize
        end
        def default_public_value
            self.is_public = true
        end
end
