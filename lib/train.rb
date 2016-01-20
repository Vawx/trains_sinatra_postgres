class Train
  attr_reader(:city)
  define_method(:initialize) do |attributes|
    @city = attributes.fetch(:city)
  end
end
