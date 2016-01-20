require 'rspec'
require 'train'
require 'city'

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
end
