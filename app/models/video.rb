class Video < ActiveRecord::Base
  include VideoUploader::Attachment.new(:video)
  #include DynamicImageUploader::Attachment.new(:video)
end