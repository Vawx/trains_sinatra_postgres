require 'rspec'
require 'train'
require 'city'
require 'pg'

TRAIN_DB = PG.connect({:dbname => 'train_test'})

RSpec.configure do |config|
  config.after(:each) do
    TRAIN_DB.exec("DELETE FROM city *;")
    TRAIN_DB.exec("DELETE FROM train *;")
  end
end

describe Train do
  describe "#newTrain" do
    it 'makes a new train' do
      new_train = Train.new( {city: "portland"} )
      expect(new_train.city).to(eq("portland"))
    end
  end
end

describe City do
  describe "#newCity" do
    it 'makes a new city' do
      new_city = City.new( {name: "portland"} )
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
end
