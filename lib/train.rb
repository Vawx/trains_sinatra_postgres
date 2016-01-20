class Train
  attr_reader(:city)
  define_method(:initialize) do |attributes|
    @city = attributes.fetch(:city)
  end

  define_method(:==) do |other|
    return self.city == other.city
  end

  define_singleton_method(:add_train_to_db) do |train_city|
    result = TRAIN_DB.exec( "INSERT INTO train (city) VALUES ('#{train_city.city}');" )
  end

  define_singleton_method(:find_train_in_db) do |by_city|
    trains_found = TRAIN_DB.exec("SELECT * FROM train WHERE city = '#{by_city}'")
    trains = []
    trains_found.each do |train|
      trains.push( Train.new( {city: train.fetch( "city" ) } ) )
    end
    return trains
  end
end
