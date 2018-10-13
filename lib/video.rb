module Youtube
  class Video
    def initialize(videos_data)
      @videos_data = videos_data
    end

    def get_first_video
      @first_video = @videos_data['items'][0]['snippet']
    end

    def get_first_video_title
      @first_video['title']
    end

    def get_first_video_id
      @first_video['resourceId']['videoId']
    end
  end
end
