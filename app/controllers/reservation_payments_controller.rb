class ReservationPaymentsController < ApplicationController
    before_action :authenticate_user!

    def create
      #stripe_customer = Stripe::Customer.create(email: current_user.email)
      token = CreditCardsController.get_token(params)
      #puts "token : ", token
      stripe_card =  Stripe::Customer.create_source(stripe_customer.id, { source: token.id })
      charge = Stripe::Charge.create(
        amount: Money.from_amount(BigDecimal(payment_params[:total])).cents,
        currency: "eur",
        source: stripe_card.id,
        customer: stripe_customer.id,
        description: 'Rails Stripe customer',
      )
      #puts "charge : ", charge
      reservation = Reservation.create(
        gymhouse: gymhouse,
        user: user,
        checkin_date: Date.strptime(payment_params[:checkin_date], Date::DATE_FORMATS[:us_short_date]),
        checkout_date: Date.strptime(payment_params[:checkout_date], Date::DATE_FORMATS[:us_short_date])
      )
      #puts "reservation : ", reservation
      payment = Payment.create(
        reservation: reservation,
        subtotal: Money.from_amount(BigDecimal(payment_params[:subtotal])),
        service_fee: Money.from_amount(BigDecimal(payment_params[:service_fee])),
        total: Money.from_amount(BigDecimal(payment_params[:total])),
        stripe_id: charge.id
      )
      #puts "payment : ", payment
  
      redirect_to root_path
    end
  
    private
  
    def payment_params
    #  params.permit(:user_id, :gymhouse_id, :number, :exp_month, :exp_year, :cvc)
                     
                    
      params.permit(:gymhouse_id, :user_id, :checkin_date, :checkout_date,
                    :subtotal, :service_fee, :total, :number, :exp_month, 
                    :exp_year, :cvc, :authenticity_token, :commit)
    end
  
    def user
      #puts "payment_params user : ", payment_params
      @user ||= User.find(payment_params[:user_id])
    end
  
    def gymhouse
      #puts "payment_params gymhouse : ", payment_params
      @gymhouse ||= Gymhouse.find(payment_params[:gymhouse_id])
    end
  
    # Creation du client dans stripe et mise à jour de la clef externe sur la base client
    def stripe_customer
      @stripe_customer ||= if user.stripe_id.blank?
                             customer = Stripe::Customer.create(email: user.email)
                             user.update(stripe_id: customer.id)
                             customer
                           else
                             Stripe::Customer.retrieve(user.stripe_id)
                           end
    end
  end