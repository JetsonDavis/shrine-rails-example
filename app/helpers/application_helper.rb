module ApplicationHelper
  def upload_server
    if Rails.env.production? or ENV['local_or_s3'] == 's3'
      :s3
    else
      :app
    end
  end
end
