require 'spec_helper'

RSpec.describe Booking do
  it 'should create a Booking' do
    count_before = Booking.all.count
    movie = Movie.create(name: "new movie", description: "description", image_url: "url", days_of_week: "1,3,5")
    function = Function.create(date: DateTime.now, movie: movie, limit: 10)
    user = User.create(document_id: 123456, name: "new user")
    booking = Booking.new(function: function, user: user, num_persons: 2)
    booking.save
    count_after = Booking.all.count
    expect(count_before).to be < count_after
    expect(booking).to be_valid
    expect(booking.function_id).to eq(function.id)
    expect(booking.user_id).to eq(user.id)
  end
end
