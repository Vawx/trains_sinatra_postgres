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
  @cities = Train.get_all_cities_for_train(train_by_number)
  erb :train
end

get '/update_city/:id' do
  @city = City.find_city_in_db(params[:id].to_i)
  erb :city
end

get '/filter_train' do
  if params.fetch("search_field").to_s.length > 0
    cities = City.find_by_partial_name( params.fetch("search_field").to_s )
    if !cities.empty?
      found_city = City.find_id_by_city_name( cities[ 0 ].fetch( "name" ) )
      redirect '/update_city/' + found_city.to_s
    end
  end
  redirect '/'
end

post '/update_city/:id/:number' do
  Train.delete_train(params[:id].to_i)
  @city = City.find_city_in_db(params[:number].to_i)
  erb :city
end

post '/add_city' do
  city_name = params.fetch("city")
  City.add_city_to_db(City.new({name: city_name}))
  redirect '/'
end

delete '/delete_city' do
  city_name = params.fetch("city")
  City.delete_from_db(city_name)
  redirect '/'
end

post '/add_train' do
  train_name = params.fetch("name")
  city_name = params.fetch("city")
  city = City.find_by_partial_name(city_name)
  if !city.empty?
    train_db_id = Train.add_train_to_db(Train.new( {name: train_name } ) )
    Train.attach_to_city(train_db_id, city)
  else
    city = City.find_city_in_db(City.add_city_to_db(City.new({name: city_name})))
    train_db_id = Train.add_train_to_db(Train.new( {name: train_name } ) )
    Train.attach_to_city(train_db_id, city)
  end
  redirect '/'
end

post '/add_city_to_train' do
  train = Train.get_train_by_number(params[:number])
  city = City.find_by_partial_name(params[:city])
  if !city.empty?
    Train.attach_to_city(train.first.fetch("number"), city)
  else
    city = City.find_city_in_db(City.add_city_to_db(City.new({name: params[:city]})))
    Train.attach_to_city(train.first.fetch("number"), city)
  end
  redirect '/'
end
