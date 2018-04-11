class ExpertsController < ApplicationController
  def index
    @experts = Expert.all
  end
  
  def show
    @expert = Expert.includes(:headlines).where(id: params[:id]).first
    @headlines = @expert.headlines
    @friendships = @expert.with_friends
  end
  
  def new
    @expert = Expert.new
  end
  
  def create
    @expert = Expert.create(expert_params)
    if @expert.persisted?
      flash[:success] = "Successfully created expert"
      redirect_to :root
    else
      render :new
    end
  end
  
  def update
  end
  
  def destroy
  end
  
  private
  
  def expert_params
    params.require(:expert).permit(:name, :url)
  end
end
