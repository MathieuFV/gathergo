class VotesController < ApplicationController
  before_action :set_destination
  before_action :set_vote, only: [:destroy]

  def create
    # Vérifions d'abord si un vote existe déjà
    existing_vote = current_user.votes.find_by(votable: @destination)
    
    if existing_vote
      Rails.logger.info "Vote already exists for user #{current_user.id} on destination #{@destination.id}"
      render json: { 
        success: false, 
        errors: ["You have already voted for this destination"] 
      }, status: :unprocessable_entity
      return
    end

    @vote = current_user.votes.build(votable: @destination)
    
    if @vote.save
      Rails.logger.info "Vote created successfully for user #{current_user.id} on destination #{@destination.id}"
      render json: { 
        success: true, 
        votes_count: @destination.votes.count 
      }
    else
      Rails.logger.error "Vote creation failed: #{@vote.errors.full_messages}"
      render json: { 
        success: false, 
        errors: @vote.errors.full_messages 
      }, status: :unprocessable_entity
    end
  end

  def destroy
    if @vote.nil?
      Rails.logger.error "Vote not found for user #{current_user.id} on destination #{@destination.id}"
      render json: { 
        success: false, 
        errors: ["Vote not found"] 
      }, status: :unprocessable_entity
      return
    end

    if @vote.destroy
      Rails.logger.info "Vote destroyed successfully for user #{current_user.id} on destination #{@destination.id}"
      render json: { 
        success: true, 
        votes_count: @destination.votes.count 
      }
    else
      Rails.logger.error "Vote destruction failed: #{@vote.errors.full_messages}"
      render json: { 
        success: false, 
        errors: @vote.errors.full_messages 
      }, status: :unprocessable_entity
    end
  end

  private

  def set_destination
    @destination = Destination.find(params[:destination_id])
  end

  def set_vote
    @vote = current_user.votes.find_by(votable: @destination)
  end
end
