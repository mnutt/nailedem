require 'rubygems'
require 'sinatra'

ROOT = File.expand_path(File.dirname(__FILE__))

post '/create' do
  url = params[:url]
  width, height = params[:width], params[:height]
end
