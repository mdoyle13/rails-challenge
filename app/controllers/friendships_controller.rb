class FriendshipsController < ApplicationController
  def create
    @friendship = Friendship.new(friendship_params)
    if @friendship.save
      flash[:success] = "Friend added"
      redirect_to expert_path(@friendship.expert)
    else
    end
  end
  
  def destroy
  end
  
  private
  def friendship_params
    params.require(:friendship).permit(:friend_id, :expert_id)
  end
end
