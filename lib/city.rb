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

  define_singleton_method(:add_city_to_db) do |city|
    result = TRAIN_DB.exec( "INSERT INTO city (name) VALUES ('#{city.name}') RETURNING id;" )
    @id = result.first.fetch("id")
  end

  define_singleton_method(:find_city_in_db) do |id|

  end
end
