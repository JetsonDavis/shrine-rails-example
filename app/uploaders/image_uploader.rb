# This is a subclass of Shrine base that will be further configured for it's requirements.
# This will be included in the model to manage the file.

class ImageUploader < Shrine
  ALLOWED_TYPES = %w[image/jpeg image/png video/mp4 video/quicktime]

  plugin :remove_attachment
  plugin :pretty_location
  plugin :validation_helpers
  plugin :store_dimensions, analyzer: :mini_magick

  # File validations (requires `validation_helpers` plugin)
  Attacher.validate do
    puts ("ATTACHER VALIDATION")
    if validate_mime_type_inclusion(ALLOWED_TYPES)
      validate_max_width 5000
      validate_max_height 5000
    end
  end
end
