class FriendshipsController < ApplicationController
  def create
    @friendship = Friendship.new(friendship_params)
    
    if @friendship.save
      flash[:success] = "Friend added"
    else
      flash[:error] = @friendship.errors.full_messages.to_sentence
    end
    
    redirect_back(fallback_location: expert_path(@friendship.expert))
  end
  
  def destroy
    @friendship = Friendship.find(params[:id])
    @friendship.destroy
    flash[:success] = "Successfully destroyed friendship"

    redirect_back(fallback_location: expert_path(@friendship.expert))
  end
  
  private
  
  def friendship_params
    params.require(:friendship).permit(:friend_id, :expert_id)
  end
end
