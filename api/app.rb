require 'sinatra'

# Définition d'une route GET
get '/' do
  "Hello, world!"
end

# Définition d'une route JSON
get '/api/hello' do
  content_type :json
  { message: "Hello from Sinatra!" }.to_json
end