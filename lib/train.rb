class Train
  attr_accessor(:name, :number)
  define_method(:initialize) do |attributes|
    @name = attributes.fetch(:name)
    @number = attributes.fetch(:number, nil)
  end

  define_method(:==) do |other|
    return self.city == other.city
  end

  define_singleton_method(:attach_to_city) do |train_id, city|
    if city.class == Array
      city_id = city[0].fetch("id")
    else
      city_id = city.id
    end
    TRAIN_DB.exec("INSERT INTO train_city (train_number, city_id) VALUES (#{train_id},'#{city_id}');")
  end

  define_singleton_method(:get_train_by_number) do |number|
    return TRAIN_DB.exec( "SELECT * FROM train WHERE number = #{number.to_i};" )
  end

  define_singleton_method(:add_train_to_db) do |train|
    result = TRAIN_DB.exec( "INSERT INTO train (name) VALUES ('#{train.name}') RETURNING number;" )
    return result.first.fetch("number")
  end

  define_singleton_method(:find_train_in_db) do |by_name|
    trains_found = TRAIN_DB.exec("SELECT * FROM train WHERE name = '#{by_name}'")
    trains = []
    trains_found.each do |train|
      trains.push( Train.new( {name: train.fetch( "name" ), number: train.fetch( "number" ) } ) )
    end
    return trains
  end

  define_singleton_method(:get_all_cities_for_train) do |train|
    all_cities_for_train = TRAIN_DB.exec("SELECT city.* FROM train
                                          JOIN train_city ON (train.number = train_city.train_number)
                                          JOIN city ON (train_city.city_id = city.id)
                                          WHERE train.number = #{train.first.fetch('number')};")
    cities = []
    all_cities_for_train.each do |city|
      new_city = City.new( {name: city.fetch("name"), id: city.fetch("id") } )
      cities.push( new_city )
    end
    return cities
  end

  define_singleton_method(:delete_train) do |train_number|
    TRAIN_DB.exec("DELETE FROM train WHERE number = #{train_number.to_i};")
  end

  define_singleton_method(:all) do
    trains_found = TRAIN_DB.exec("SELECT * FROM train;")
    trains = []
    trains_found.each do |train|
      trains.push( Train.new( {name: train.fetch( "name" ), number: train.fetch("number") } ) )
    end
    return trains
  end
end
