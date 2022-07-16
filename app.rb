require 'sinatra'
require "sinatra/reloader" if development?
require "sinatra/json"

get '/callback' do
  200
end

post '/callback' do
end
