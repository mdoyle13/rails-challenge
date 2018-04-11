class ExpertsController < ApplicationController
  before_action :load_expert, only: [:show, :manage_friends]
  
  def index
    @experts = Expert.all
  end
  
  def show
    @headlines = @expert.headlines
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
  
  def manage_friends
    @options_for_friend_selection = @expert.not_self_and_not_already_friends(@friendships.collect(&:friend_id))
    
    if params[:search]
      experts_search
    end
  end
  
  def update
  end
  
  def destroy
  end
  
  private
  
  def load_expert
    @expert = Expert.where(id: params[:id]).first
    @friendships = @expert.with_friends
  end
  
  def expert_params
    params.require(:expert).permit(:name, :url)
  end
  
  def experts_search
    @search = params[:search]
    @headlines = Headline.includes(:expert).search_by_text_content(@search)
    expert_ids = @headlines.collect(&:expert_id).uniq
    
    unless expert_ids.present?
      @results = nil
      return
    end
    
    friend_of_friend_ids = Expert.get_friends_of_friends_ids(@expert.id)
    
    @results = Expert.where(id: expert_ids && friend_of_friend_ids)
  end
  
  
  
  
  
  
  
  
end
