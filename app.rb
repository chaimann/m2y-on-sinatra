require 'sinatra'
require 'sinatra/reloader' if development?
require 'sinatra/json'
require 'active_support/core_ext/hash/keys'
require 'active_support/core_ext/string/inflections'
require_relative './lib/import_transaction'
use Rack::Logger, 0

get '/callback' do
  200
end

post '/callback' do
  request.body.rewind
  payload = JSON.parse(request.body.read)
  stat_params = payload.deep_transform_keys(&:underscore).deep_transform_keys(&:to_sym).fetch(:data)
  account_id = stat_params.fetch(:account)
  item = stat_params.fetch(:statement_item)

  importer = ImportTransaction.new(account_id, item)
  result = importer.perform
  request.logger.error(importer.error) unless result

  200
end
