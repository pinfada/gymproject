class GymhousesController < ApplicationController
  before_action :authenticate_user!
  def show
    @gymhouse = Gymhouse.find(params[:id])
  end

  def new
    @gymhouse = Gymhouse.new
  end

	def create
    @gymhouse = Gymhouse.create(gymhouse_params)
    if @gymhouse.save
      redirect_to root_path
    else
      render :new
    end
	end

	private

		# Never trust parameters from the scary internet, only allow the white list through.
		def gymhouse_params
		  params.require(:gymhouse).permit(:name, :address1, :address2, :headline,
                                       :country, :postal, :state, :city, :customer_id,
                                       :prospect_id, :description, :price)
		end

end
