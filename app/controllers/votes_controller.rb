class VotesController < ApplicationController
  def create
    @vote = current_user.votes.build(vote_params)

    if @vote.save
      redirect_back(fallback_location: root_path, notice: 'Vote added!')
    else
      redirect_back(fallback_location: root_path, alert: 'Error adding vote')
    end
  end

  def destroy
    @vote = current_user.votes.find_by(votable_type: params[:votable_type], votable_id: params[:votable_id])
    @vote.destroy if @vote

    redirect_back(fallback_location: root_path, notice: 'Vote removed')
  end

  private

  def vote_params
    params.require(:vote).permit(:votable_type, :votable_id)
  end
end
