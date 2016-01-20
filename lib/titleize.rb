
class String
  define_method(:titleize) do
    split = self.split(" ")
    split.each do |word|
      word.capitalize!
    end
    split.join(" ")
  end
end
