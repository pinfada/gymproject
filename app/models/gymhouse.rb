class Gymhouse < ApplicationRecord
	belongs_to :customer, class_name: "User", foreign_key: :customer_id, optional: true
	belongs_to :prospect, class_name: "User", foreign_key: :prospect_id, optional: true

    has_many :reservations, dependent: :destroy
    has_many :reserved_users, through: :reservations, source: :user
    has_one_attached :avatar, dependent: :destroy
    
    validates :name, presence: true
    validates :headline, presence: true
    validates :description, presence: true
    validates :city, presence: true
    validates :state, presence: true
    validates :postal, presence: true
    validates :country, presence: true
    validates :address1, presence: true

    monetize :price_cents, allow_nil: true
    
    def address
        [address1, city, country].compact.join(', ')
    end

    geocoded_by :address
    before_validation :geocode, if: ->(obj){ obj.address.present? and address_changed?(obj) }
    after_validation :lat_changed?

    def available_dates
        date_format = "%b %e"
        next_reservation = reservations.future_reservations.order(checkout_date: :desc).first
        return Date.tomorrow.strftime(date_format)..Date.today.end_of_year.strftime(date_format) if next_reservation.nil?
    
        next_reservation.checkout_date.strftime(date_format)..Date.today.end_of_year.strftime(date_format)
    end

    private
        # Attention, si l'adresse est dans la même rue
        # Ce test génère une anomalie si la localisation n'a pas changée suite au changement d'adresse
        def lat_changed?
            if (address_changed?(self) && !(self.latitude_changed?))
                self.errors.add(:address, "is not valid")
                return false
            else
                return true
            end
            
        end

        def address_changed?(obj)
            if ( obj.address1_changed? || obj.city_changed? || obj.country_changed? )
                return true
            else
                return false
            end
        end

end
