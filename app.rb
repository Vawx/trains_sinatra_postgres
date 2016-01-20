require 'sinatra'
require 'sinatra/reloader'
require 'pry'
require 'pg'
require './lib/titleize'
require './lib/city'
require './lib/train'
also_reload( './lib/**/*.rb')

TRAIN_DB = PG.connect( {:dbname => 'train'})

get '/' do
  @all_cities = City.all
  erb :index
end

get '/update_train/:id' do
  train_by_number = Train.get_train_by_number(params[:id])
  @train = train_by_number
  erb :train
end

get '/update_city/:id' do
  @city = City.find_city_in_db(params[:id].to_i)
  erb :city
end

post '/update_city/:id/:number' do
  Train.delete_train(params[:id].to_i)
  @city = City.find_city_in_db(params[:number].to_i)
  erb :city
end

post '/add_train' do
  train_city = params.fetch("train_city")
  if !City.city_exists?(train_city)
    City.add_city_to_db(City.new({name: train_city.titleize}))
  end
  City.get_all_trains_in_city(train_city).length
  Train.add_train_to_db(Train.new( {city: train_city.titleize, number: City.get_all_trains_in_city(train_city).length + 1} ) )
  redirect '/'
end
