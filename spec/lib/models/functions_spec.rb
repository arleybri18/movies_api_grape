require 'spec_helper'

RSpec.describe Function do
  it 'should create a Function' do
    count_before = Function.all.count
    movie = Movie.create(name: "new movie", description: "description", image_url: "url", days_of_week: "1,3,5")
    function = Function.new(date: DateTime.now, movie: movie, limit: 10)
    function.save
    count_after = Function.all.count
    expect(count_before).to be < count_after
    expect(function).to be_valid
    expect(function.movie_id).to eq(movie.id)
  end
end
