require 'pry'
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

  define_singleton_method(:add_city_to_db) do |city|
    result = TRAIN_DB.exec( "INSERT INTO city (name) VALUES ('#{city.name}') RETURNING id;" )
    @id = result.first.fetch("id")
    return @id
  end

  define_singleton_method(:find_city_in_db) do |id|
    all_found_cities = TRAIN_DB.exec( "SELECT * FROM city;" )
    all_found_cities.each do |city|
      if city.fetch("id") == id.to_s
        return_city = City.new( {name: city.fetch("name"), id: city.fetch("id")})
        return return_city
      end
    end
  end
end
