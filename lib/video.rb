# frozen_string_literal: true

module Youtube
  # Store information about videos from channel's playlist
  class Video
    def initialize(videos_data)
      @videos_data = videos_data
    end

    def first_video
      @first_video = @videos_data['items'][0]['snippet']
    end

    def first_video_title
      @first_video['title']
    end

    def first_video_id
      @first_video['resourceId']['videoId']
    end
  end
end
