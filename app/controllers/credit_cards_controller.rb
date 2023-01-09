class CreditCardsController < ApplicationController
  before_action :authenticate_user!
  def self.get_token(params)
    #puts "params : ", params
    @number = params[:number]
    @exp_month = params[:exp_month]
    @exp_year = params[:exp_year]
    @cvc = params[:cvc]
    Stripe::Token.create(card: { number: @number,
                                 exp_month: @exp_month,
                                 exp_year: @exp_year,
                                 cvc: @cvc })
  end
end
