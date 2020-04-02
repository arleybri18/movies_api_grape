require 'spec_helper'

RSpec.describe Movie do
  it 'should create a Movie' do
    count_before = Movie.all.count
    movie = Movie.new(name: "New movie", description: "Description test", image_url: "url", days_of_week: "1,3,5")
    movie.save
    count_after = Movie.all.count
    expect(count_before).to be < count_after
    expect(movie).to be_valid
    expect(movie.name).to eq("New movie")
  end
end
