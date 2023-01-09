class Profile < ApplicationRecord
  belongs_to :user

  validates :user_id, presence: true

  has_one_attached :avatar, dependent: :destroy

  def address
      [address1, city, country].compact.join(', ')
  end

  geocoded_by :address
  before_validation :geocode, if: ->(obj){ obj.address.present? and address_changed?(obj) }
  after_validation :lat_changed?

  private
      # Attention, si l'adresse est dans la même rue
      # Ce test génère une anomalie si la localisation n'a pas changée suite au changement d'adresse
      def lat_changed?
          if (address_changed?(self) && !(self.latitude_changed?))
              self.errors.add(:address, "is not valid")
              return false
          end
          return true
      end

      def address_changed?(obj)
          if ( obj.address1_changed? || obj.city_changed? || obj.country_changed? )
          return true
          end
          return false
      end

end
