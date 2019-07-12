Rails.application.routes.draw do
  root to: "albums#index"

  resources :albums

  if Rails.env.production? or ENV['local_or_s3'] == 's3'
    mount Shrine.presign_endpoint(:cache) => "/s3/params"
  else
    # In development and test environment we're using filesystem storage
    # for speed, so on the client side we'll upload files to our app.
    mount Shrine.upload_endpoint(:cache) => "/upload"
  end

  #mount DynamicImageUploader.derivation_endpoint => "/derivations/image"
  mount VideoUploader.derivation_endpoint => "/derivations/image"
end
