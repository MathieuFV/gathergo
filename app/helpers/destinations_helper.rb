module DestinationsHelper
    def destination_proposal_data(destination)
        {
        title: destination.name,
        image_url: destination_image_url(destination),
        comments_count: destination.comments_count || destination.comments.count || 0,
        likes_count: destination.votes_count || destination.votes.count || 0,
        user: {
            name: destination.owner&.first_name || "Unknown",
            avatar_url: user_avatar_url(destination.owner)
        },
        created_at: destination.created_at,
        link_path: Rails.application.routes.url_helpers.trip_destination_path(destination.trip, destination)
        }
    end

    private

    def destination_image_url(destination)
        if destination.photos.attached?
        cl_image_path(destination.photos.first.key)
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