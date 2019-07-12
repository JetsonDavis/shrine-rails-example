class Photo < ActiveRecord::Base
  include DynamicImageUploader::Attachment.new(:image)  # ImageUploader will attach and manage `image`
  #include VideoUploader::Attachment.new(:video)  # ImageUploader will attach and manage `video`
end
