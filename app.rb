require 'sinatra'
require 'sinatra/reloader' if development?
require 'sinatra/json'
require 'active_support/core_ext/hash/keys'
require 'active_support/core_ext/string/inflections'
require_relative './lib/import_transaction'

get '/callback' do
  puts 'success'
  200
end

post '/callback' do
  request.body.rewind
  payload = JSON.parse(request.body.read)
  stat_params = payload.deep_transform_keys(&:underscore).deep_transform_keys(&:to_sym).fetch(:data)
  account_id = stat_params.fetch(:account)
  item = stat_params.fetch(:statement_item)
  ImportTransaction.new(account_id, item).perform
  200
end
