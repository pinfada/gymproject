class HomeController < ApplicationController
  before_action :authenticate_user!
  def index
    @titre = "Homepage"
    #@gymhouses = Gymhouse.all.order("created_at ASC")
    # All ready reserved
    if current_user.prospect?
      # Verifier si le prospect est déjà inscrit à une salle et afficher les salles
      @gymhouses = Gymhouse.all.distinct
      #@gymhouses = Gymhouse.where.not(customer_id: current_user)
      #puts "prospect : ", @gymhouses
    else
      # Vérifier si le client  déjà enregistré une salle et l'affichée
      @gymhouses = Gymhouse.where(prospect_id: current_user)
      #puts "customer : ", @gymhouses
    end
  end
  def about
  end
end
