require "streamio-ffmpeg"
require "tempfile"

# uploader showcasing on-the-fly processing
class VideoUploader < ImageUploader
  plugin :add_metadata
  plugin :validation_helpers
  plugin :processing
  plugin :versions
  plugin :delete_raw
  Shrine.plugin :tempfile

  add_metadata do |io, context|
    movie = Shrine.with_file(io) { |file| puts "FP: "+file.path;FFMPEG::Movie.new(file.path) }
    { "duration"   => movie.duration,
      "bitrate"    => movie.bitrate,
      "resolution" => movie.resolution,
      "frame_rate" => movie.frame_rate
    }

    puts "MOVIE DURATION: " + movie.duration.to_s
    puts "MOVIE BITRATE: " + movie.bitrate.to_s
    puts "MOVIE RESOLUTION: " + movie.resolution.to_s
    puts "MOVIE FRAME RATE: " + movie.frame_rate.to_s
    puts "MOVIE INSPECT: " + movie.inspect + "\n\n"

  end

  process(:store) do |io, context|
  versions = {original: io}

    io.download do |original|
      screenshot1 = Tempfile.new(["screenshot1", ".jpg"], binmode: true)
      screenshot2 = Tempfile.new(["screenshot2", ".jpg"], binmode: true)
      screenshot3 = Tempfile.new(["screenshot3", ".jpg"], binmode: true)
      screenshot4 = Tempfile.new(["screenshot4", ".jpg"], binmode: true)

      movie = FFMPEG::Movie.new(original.path)
      movie.screenshot(screenshot1.path, seek_time: 5, resolution: '640x480')
      movie.screenshot(screenshot2.path, seek_time: 10, resolution: '640x480')
      movie.screenshot(screenshot3.path, seek_time: 15, resolution: '640x480')
      movie.screenshot(screenshot4.path, seek_time: 20, resolution: '640x480')

      [screenshot1, screenshot2, screenshot3, screenshot4].each(&:open) # refresh file descriptors

      versions.merge!(screenshot1: screenshot1, screenshot2: screenshot2, screenshot3: screenshot3, screenshot4: screenshot4)
    end

    versions
  end

  Attacher.validate do
    validate_max_size 100.megabyte, message: "is too large (max is 100 MB)"
    validate_mime_type_inclusion ALLOWED_TYPES
  end
end