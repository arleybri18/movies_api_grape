module Models
  class Movie < Sequel::Model(:movies)
    one_to_many :functions
  end
end