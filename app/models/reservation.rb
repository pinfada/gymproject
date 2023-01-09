class Reservation < ApplicationRecord
  belongs_to :gymhouse
  belongs_to :user
  has_one :payment, dependent: :destroy

  validates :checkin_date, presence: true
  validates :checkout_date, presence: true

  # Permet de vérifier si il ya des salle dispo à la date souhaitée
  scope :future_reservations, -> { where("checkout_date > ?", Date.today)}

end
