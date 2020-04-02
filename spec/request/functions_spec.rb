require 'spec_helper'

RSpec.describe '/api/v1/functions' do

  context "Success" do
    it "should get all functions" do
      movie = Movie.create(name: "new movie", description: "description", image_url: "url", days_of_week: "1,3,5")
      function = Function.create(date: DateTime.now, movie: movie, limit: 10)
      get '/api/v1/functions'
      body = JSON.parse(last_response.body)
      expect(last_response.status).to eq(200)
      expect(body["data"][0]["date"]).not_to be_nil
      expect(body["data"][0]["movie"]["name"]).to eq(function.movie.name)
      expect(body["data"][0]["limit"]).to eq(function.limit)
    end

    it "should get one function by id" do
      movie1 = Movie.create(name: "new movie1", description: "description1", image_url: "url1", days_of_week: "1,3,5")
      function1 = Function.create(date: DateTime.now, movie: movie1, limit: 10)
      movie2 = Movie.create(name: "new movie2", description: "description2", image_url: "url2", days_of_week: "1,3,5")
      function2 = Function.create(date: DateTime.now, movie: movie2, limit: 10)
      get "/api/v1/functions/#{function1.id}"
      body = JSON.parse(last_response.body)
      expect(last_response.status).to eq(200)
      expect(body["data"]["date"]).not_to be_nil
      expect(body["data"]["movie"]["name"]).to eq(function1.movie.name)
      expect(body["data"]["limit"]).to eq(function1.limit)

      get "/api/v1/functions/#{function2.id}"
      body = JSON.parse(last_response.body)
      expect(last_response.status).to eq(200)
      expect(body["data"]["date"]).not_to be_nil
      expect(body["data"]["movie"]["name"]).to eq(function2.movie.name)
      expect(body["data"]["limit"]).to eq(function2.limit)
    end

    it "should create a function" do
      movie = Movie.create(name: "new movie1", description: "description1", image_url: "url1", days_of_week: "1,3,5")
      params = {date: DateTime.now, movie_id: movie.id, limit: 15}
      count_before = Function.all.count
      post '/api/v1/functions', params
      body = JSON.parse(last_response.body)
      count_after = Function.all.count
      expect(count_before).to be < count_after
      expect(last_response.status).to eq(201)
      expect(body["date"]).not_to be_nil
      expect(body["movie_id"]).to eq(movie.id)
      expect(body["limit"]).to eq(params[:limit])
    end

    it "should update a function" do
      movie1 = Movie.create(name: "new movie1", description: "description1", image_url: "url1", days_of_week: "1,3,5")
      movie2 = Movie.create(name: "new movie2", description: "description2", image_url: "url2", days_of_week: "1,3,5")
      function = Function.create(date: DateTime.now, movie: movie1, limit: 10)
      count_before = Function.all.count
      params = {movie_id: movie2.id, limit: 15}
      put "/api/v1/functions/#{function.id}", params
      body = JSON.parse(last_response.body)
      count_after = Function.all.count
      expect(count_before).to eq(count_after)
      expect(last_response.status).to eq(200)
      expect(body["movie_id"]).to eq(movie2.id)
      expect(body["limit"]).to eq(params[:limit])
    end

    it "should delete a function" do
      movie1 = Movie.create(name: "new movie1", description: "description1", image_url: "url1", days_of_week: "1,3,5")
      function = Function.create(date: DateTime.now, movie: movie1, limit: 10)
      count_before = Function.all.count
      delete "/api/v1/functions/#{function.id}"
      count_after = Function.all.count
      expect(count_before).to be > count_after
      expect(last_response.status).to eq(200)
    end

  end

  context "Failure" do

    it "dont should get one function by id if not exists" do
      movie1 = Movie.create(name: "new movie1", description: "description1", image_url: "url1", days_of_week: "1,3,5")
      function = Function.create(date: DateTime.now, movie: movie1, limit: 10)
      get "/api/v1/functions/3"
      body = JSON.parse(last_response.body)
      expect(last_response.status).to eq(404)
    end

    it "dont should create a function if parameters misisng" do
      movie = Movie.create(name: "new movie1", description: "description1", image_url: "url1", days_of_week: "1,3,5")
      params = {movie_id: movie.id, limit: 15}
      count_before = Function.all.count
      post '/api/v1/functions', params
      body = JSON.parse(last_response.body)
      count_after = Function.all.count
      expect(count_before).to eq(count_after)
      expect(last_response.status).to eq(400)
      expect(body["error"]).to eq("date is missing")
    end

    it "dont should update a function if not exists" do
      movie1 = Movie.create(name: "new movie1", description: "description1", image_url: "url1", days_of_week: "1,3,5")
      function = Function.create(date: DateTime.now, movie: movie1, limit: 10)
      params = {movie_id: movie1.id, limit: 15}
      put "/api/v1/functions/3", params
      body = JSON.parse(last_response.body)
      expect(last_response.status).to eq(404)
    end

    it "dont should delete a function if not exists" do
      movie1 = Movie.create(name: "new movie1", description: "description1", image_url: "url1", days_of_week: "1,3,5")
      function = Function.create(date: DateTime.now, movie: movie1, limit: 10)
      count_before = Function.all.count
      delete "/api/v1/functions/3"
      count_after = Function.all.count
      expect(count_before).to eq(count_after)
      expect(last_response.status).to eq(404)
    end
  end
end