require "shrine"

# use S3 for production and local file for other environments
if Rails.env.production? or ENV['local_or_s3'] == 's3'
  require "shrine/storage/s3"

  s3_options = {
    access_key_id:     ENV['s3_access_key_id'],
    secret_access_key: ENV['s3_secret_access_key'],
    region:            ENV['s3_region'],
    bucket:            ENV['s3_bucket'],
  }

  # both `cache` and `store` storages are needed
  Shrine.storages = {
    cache: Shrine::Storage::S3.new(prefix: "cache", **s3_options),
    store: Shrine::Storage::S3.new(**s3_options),
  }
else
  puts "DEV LOCAL MODE"
  require "shrine/storage/file_system"

  # both `cache` and `store` storages are needed
  Shrine.storages = {
    cache: Shrine::Storage::FileSystem.new("public", prefix: "uploads/cache"),
    store: Shrine::Storage::FileSystem.new("public", prefix: "uploads"),
  }
end

Shrine.plugin :activerecord
Shrine.plugin :logging
Shrine.plugin :determine_mime_type
Shrine.plugin :cached_attachment_data
Shrine.plugin :restore_cached_data

if Rails.env.production? or ENV['local_or_s3'] == 's3'
  Shrine.plugin :presign_endpoint, presign_options: -> (request) {

    # Uppy will send the "filename" and "type" query parameters
    filename = request.params["filename"]
    type     = request.params["type"]
    puts filename
    {
      content_disposition:    ContentDisposition.inline(filename), # set download filename
      content_type:           type,                                # set content type
      content_length_range:   0..(1000*1024*1024),                   # limit upload size to 1000 MB
    }
  }
else
  Shrine.plugin :upload_endpoint
end

Shrine.plugin :derivation_endpoint,
  secret_key: "secret",
  download_errors: [defined?(Shrine::Storage::S3) ? Aws::S3::Errors::NotFound : Errno::ENOENT]

# delay promoting and deleting files to a background job (`backgrounding` plugin)
Shrine.plugin :backgrounding
Shrine::Attacher.promote { |data| PromoteJob.perform_async(data) }
Shrine::Attacher.delete { |data| DeleteJob.perform_async(data) }
