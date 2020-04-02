module Models
  class Booking < Sequel::Model(:bookings)
    many_to_one :function
    many_to_one :user
  end
end