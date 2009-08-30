ROOT = File.expand_path(File.dirname(__FILE__))
$LOAD_PATH.unshift File.join(ROOT, "vendor", "paperclip", "lib")

require 'rubygems'
require 'sinatra'
require 'open-uri'
require 'paperclip'
require 'json'
require 'base64'

get '/' do
  erb :home
end

get '/create' do
  callback = params[:callback]
  url = params[:url]
  width, height = params[:width] || 50, params[:height] || 50
  img = {}

  open(url) do |f|
    orig = Tempfile.new(File.basename(url))
    orig.binmode
    File.open(orig.path, "w") { |o| o.write(f.read) }

    width, height = [width.to_i, 800].min, [height.to_i, 800].min # Max size is 800px
    img = Paperclip::Thumbnail.new(orig, {:geometry => "#{width}x#{height}>", :format => 'png'})
  end

  thumb = img.make
  result = {:thumbnail => {:width => width, :height => height, :data => Base64.encode64(thumb.read)}}

  if(callback)
    callback.gsub!(/[^A-Za-z0-9]/, '')
    return "#{callback}(#{result.to_json})"
  else
    return result.to_json
  end
end
