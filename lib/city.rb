class City
  attr_reader(:name, :id)
  define_method(:initialize) do |attributes|
    @name = attributes.fetch(:name)
  end

  define_method(:id) do
    result = TRAIN_DB.exec( "SELECT id FROM city WHERE name = '#{self.name}';")
    return result.first.fetch("id").to_i
  end

  define_method(:==) do |other|
    self.name == other.name && self.id == other.id
  end

  define_singleton_method(:city_exists?) do |city_name|
    current_cities = TRAIN_DB.exec("SELECT name FROM city;")
    current_cities.each do |city|
      if city.fetch("name").downcase == city_name.downcase
        return true
      end
    end
    return false
  end

  define_singleton_method(:find_id_by_city_name) do |city_name|
    result = TRAIN_DB.exec("SELECT * FROM city WHERE name = '#{city_name}'")
    found_city = City.new( { name: result.first.fetch("name"), id: result.first.fetch("id") } )
    return found_city.id
  end

  define_singleton_method(:add_city_to_db) do |city|
    result = TRAIN_DB.exec( "INSERT INTO city (name) VALUES ('#{city.name}') RETURNING id;" )
    @id = result.first.fetch("id")
    return @id
  end

  define_singleton_method(:delete_from_db) do |city_name|
    TRAIN_DB.exec("DELETE FROM city * WHERE name = '#{city_name}';")
  end

  define_singleton_method(:find_by_partial_name) do |partial|
    partial_results = TRAIN_DB.exec("SELECT * FROM city WHERE name LIKE '%#{partial.titleize}%';")
    results = []
    partial_results.each do |result|
      results.push(result)
    end
    return results
  end

  define_singleton_method(:find_city_in_db) do |id|
    all_found_cities = TRAIN_DB.exec( "SELECT * FROM city;" )
    all_found_cities.each do |city|

      if city.fetch("id").to_s == id.to_s
        return_city = City.new( {name: city.fetch("name"), id: city.fetch("id")})
        return return_city
      end
    end
    return nil
  end

  define_singleton_method(:all) do
    all_found_cities = TRAIN_DB.exec("SELECT DISTINCT * FROM city;")
    cities = []
    all_found_cities.each do |city|
      cities.push(City.new( {name: city.fetch("name"), id: city.fetch("id") } ) )
    end
    return cities
  end

  define_singleton_method(:get_all_trains_in_city) do |city|
    all_train_for_city = TRAIN_DB.exec("SELECT train.* FROM city
                                        JOIN train_city ON (city.id = train_city.city_id)
                                        JOIN train ON (train_city.train_number = train.number)
                                        WHERE city.id = #{city.id};")
    trains = []
    all_train_for_city.each do |train|
      new_train = Train.new( {name: train.fetch("name"), number: train.fetch("number") } )
      trains.push( new_train )
    end
    return trains
  end
end
