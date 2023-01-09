class ProfilesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: %i[ index ]

  def index
    post = Post.where(user_id: @user.id)
    @followers = @user.followed_users
    @postcount = post.count

    @posts = Post.not_reply.where(user_id: [@user.id, *@user.followers.pluck(:id)])
    #  current_user.id,
    #  *current_user.followings.pluck(:id)
    #  ]).includes(postable: [:place]).order("created_at DESC")

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

end
