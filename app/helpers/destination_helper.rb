# app/helpers/destinations_helper.rb
module DestinationHelper
  def destination_proposal_data(destination)
    admin_participation = destination.trip.participations.find_by(role: "admin")
    admin_user = admin_participation&.user

    {
      title: destination.name,
      image_url: destination_image_url(destination),
      comments_count: destination.comments_count || destination.comments.count || 0,
      likes_count: destination.votes_count || destination.votes.count || 0,
      user: {
        name: admin_user&.first_name || "Unknown",
        avatar_url: user_avatar_url(admin_user)
      },
      created_at: destination.created_at
    }
  end

  private

  def destination_image_url(destination)
    if destination.photo.attached?
      cl_image_path(destination.photo.key)
    else
      'fallback_destination_image_path'
    end
  end

  def user_avatar_url(user)
    if user&.photo&.attached?
      cl_image_path(user.photo.key)
    else
      'fallback_avatar_path'
    end
  end
end
