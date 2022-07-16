require 'sinatra'
require 'sinatra/reloader' if development?
require 'sinatra/json'
require_relative './lib/import_transaction'

get '/callback' do
  200
end

post '/callback' do
end
