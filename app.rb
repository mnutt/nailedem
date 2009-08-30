ROOT = File.expand_path(File.dirname(__FILE__))
$LOAD_PATH.unshift File.join(ROOT, "vendor", "paperclip", "lib")

require 'rubygems'
require 'sinatra'
require 'open-uri'
require 'paperclip'

get '/' do
  erb :home
end

post '/create' do
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

  response['Content-Disposition'] = "inline; filename='thumb.png'"
  response['Content-Type'] = "image/png"

  return img.make
end
