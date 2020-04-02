module Models
  class Function < Sequel::Model(:functions)
    one_to_many :bookings
    many_to_one :movie

    def ocupation
      self.bookings.map {|b| b.num_persons}.sum
    end
  end
end