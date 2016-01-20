class Train
  attr_accessor(:city, :number)
  define_method(:initialize) do |attributes|
    @city = attributes.fetch(:city)
    @number = attributes.fetch(:number)
  end

  define_method(:==) do |other|
    return self.city == other.city
  end

  define_singleton_method(:get_train_by_number) do |number|
    return TRAIN_DB.exec( "SELECT * FROM train WHERE number = #{number.to_i};" )
  end

  define_singleton_method(:add_train_to_db) do |train|
    result = TRAIN_DB.exec( "INSERT INTO train (city) VALUES ('#{train.city}');" )
  end

  define_singleton_method(:find_train_in_db) do |by_city|
    trains_found = TRAIN_DB.exec("SELECT * FROM train WHERE city = '#{by_city}'")
    trains = []
    trains_found.each do |train|
      trains.push( Train.new( {city: train.fetch( "city" ), number: train.fetch( "number" ) } ) )
    end
    return trains
  end

  define_singleton_method(:all) do
    trains_found = TRAIN_DB.exec("SELECT * FROM train;")
    trains = []
    trains_found.each do |train|
      trains.push( Train.new( {city: train.fetch( "city" ) } ) )
    end
    return trains
  end
end
