module Gymhouses
  class ReservationsController < ApplicationController
    before_action :authenticate_user!

    def new
      @gymhouse = Gymhouse.find(params[:gymhouse_id])
      @reservation = @gymhouse.reservations.new
      @checkin_date = new_reservation_params[:checkin_date]
      @checkout_date = new_reservation_params[:checkout_date]
      @subtotal = new_reservation_params[:subtotal]
      @service_fee = new_reservation_params[:service_fee]
      @total = new_reservation_params[:total]
    end

    private

    def new_reservation_params
      params.permit(
        :checkin_date, :checkout_date, :subtotal, :service_fee, :total, :gymhouse_id, :user_id
      )
    end
  end
end