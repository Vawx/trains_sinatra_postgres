require 'sinatra'
require 'sinatra/reloader'
require 'pry'
require 'pg'

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

post '/add_train' do
  train_city = params.fetch("train_city")
  if !City.city_exists?(train_city)
    City.add_city_to_db(City.new({name: train_city}))
  end
  City.get_all_trains_in_city(train_city).length
  new_train = Train.new( {city: train_city} )
  new_train.number = City.get_all_trains_in_city(train_city).length + 1
  Train.add_train_to_db( new_train )
  redirect '/'
end
