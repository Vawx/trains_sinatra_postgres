require 'rspec'
require 'train'
require 'city'
require 'pg'
require 'titleize'

TRAIN_DB = PG.connect({:dbname => 'train_test'})

RSpec.configure do |config|
  config.after(:each) do
    TRAIN_DB.exec("DELETE FROM city *;")
    TRAIN_DB.exec("DELETE FROM train *;")
  end
end

describe String do
  describe "#titleize" do
    it 'capitalizes words as if a title of book' do
      expect("new york city".titleize).to(eq("New York City"))
    end
  end
end

describe Train do
  describe "#newTrain" do
    it 'makes a new train' do
      new_train = Train.new( {city: "portland", number: 1} )
      expect(new_train.city).to(eq("portland"))
    end
  end
  describe ".add_train_to_db" do
    it 'adds train to the database' do
      new_train = Train.new( {city: "portland", number: 1})
      Train.add_train_to_db(new_train)
      expect(Train.find_train_in_db("portland")).to(eq([new_train]))
    end
  end
end

describe City do
  describe "#newCity" do
    it 'makes a new city' do
      new_city = City.new( {name: "portland" } )
      expect(new_city.name).to(eq("portland"))
    end
  end
  describe "#id" do
    it 'has a id' do
      new_city = City.new( {name: "portland"} )
      City.add_city_to_db( new_city )
      expect(new_city.id).to(be_instance_of(Fixnum))
    end
  end
  describe ".get_city_by_id" do
    it 'gets city by id' do
      new_city = City.new( {name: "not portland"})
      id = City.add_city_to_db(new_city)
      expect(City.find_city_in_db(new_city.id).id).to(eq(id.to_i))
    end
  end
end
