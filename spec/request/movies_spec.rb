require 'spec_helper'

RSpec.describe '/api/v1/movies' do

  context "Success" do
    it "should get all movies" do
      movie = Movie.create(name: "new movie", description: "description", image_url: "url", days_of_week: "1,3,5")
      get '/api/v1/movies'
      body = JSON.parse(last_response.body)
      expect(last_response.status).to eq(200)
      expect(body["data"][0]["id"]).to eq(movie.id)
      expect(body["data"][0]["name"]).to eq(movie.name)
      expect(body["data"][0]["description"]).to eq(movie.description)
      expect(body["data"][0]["image_url"]).to eq(movie.image_url)
    end

    it "should get one movie by id" do
      movie1 = Movie.create(name: "new movie1", description: "description1", image_url: "url1", days_of_week: "1,3,5")
      movie2 = Movie.create(name: "new movie2", description: "description2", image_url: "url2", days_of_week: "1,3,5")
      get "/api/v1/movies/#{movie1.id}"
      body = JSON.parse(last_response.body)
      expect(last_response.status).to eq(200)
      expect(body["data"]["id"]).to eq(movie1.id)
      expect(body["data"]["name"]).to eq(movie1.name)
      expect(body["data"]["description"]).to eq(movie1.description)
      expect(body["data"]["image_url"]).to eq(movie1.image_url)

      get "/api/v1/movies/#{movie2.id}"
      body = JSON.parse(last_response.body)
      expect(last_response.status).to eq(200)
      expect(body["data"]["id"]).to eq(movie2.id)
      expect(body["data"]["name"]).to eq(movie2.name)
      expect(body["data"]["description"]).to eq(movie2.description)
      expect(body["data"]["image_url"]).to eq(movie2.image_url)
    end

    it "should create a movie" do
      params = {name: "new movie", description: "description", image_url: "url", days_of_week: "1,3,5"}
      count_before = Movie.all.count
      post '/api/v1/movies', params
      body = JSON.parse(last_response.body)
      count_after = Movie.all.count
      expect(count_before).to be < count_after
      expect(last_response.status).to eq(201)
      expect(body["name"]).to eq(params[:name])
      expect(body["description"]).to eq(params[:description])
      expect(body["image_url"]).to eq(params[:image_url])
    end

    it "should update a movie" do
      movie = Movie.create(name: "new movie", description: "description", image_url: "url", days_of_week: "1,3,5")
      count_before = Movie.all.count
      params = {name: "name updated", description: "description updated", image_url: "url updated", days_of_week: "1,4,6"}
      put "/api/v1/movies/#{movie.id}", params
      body = JSON.parse(last_response.body)
      count_after = Movie.all.count
      expect(count_before).to eq(count_after)
      expect(last_response.status).to eq(200)
      expect(body["name"]).to eq(params[:name])
      expect(body["description"]).to eq(params[:description])
      expect(body["image_url"]).to eq(params[:image_url])
    end

    it "should delete a movie" do
      movie = Movie.create(name: "new movie", description: "description", image_url: "url", days_of_week: "1,3,5")
      count_before = Movie.all.count
      delete "/api/v1/movies/#{movie.id}"
      count_after = Movie.all.count
      expect(count_before).to be > count_after
      body = JSON.parse(last_response.body)
      expect(last_response.status).to eq(200)
    end

    it "should get one movie by day of week" do
      movie1 = Movie.create(name: "new movie1", description: "description1", image_url: "url1", days_of_week: "1,3,5")
      movie2 = Movie.create(name: "new movie2", description: "description2", image_url: "url2", days_of_week: "3,6")
      movie3 = Movie.create(name: "new movie3", description: "description3", image_url: "url3", days_of_week: "4,6")
      get  '/api/v1/movies/by_day/3'
      body = JSON.parse(last_response.body)
      expect(last_response.status).to eq(200)
      expect(body["total"]).to eq(2)

      expect(body["data"][0]["id"]).to eq(movie1.id)
      expect(body["data"][0]["name"]).to eq(movie1.name)
      expect(body["data"][0]["description"]).to eq(movie1.description)
      expect(body["data"][0]["image_url"]).to eq(movie1.image_url)
      expect(body["data"][0]["days_of_week"]).to eq(movie1.days_of_week)

      expect(body["data"][1]["id"]).to eq(movie2.id)
      expect(body["data"][1]["name"]).to eq(movie2.name)
      expect(body["data"][1]["description"]).to eq(movie2.description)
      expect(body["data"][1]["image_url"]).to eq(movie2.image_url)
      expect(body["data"][1]["days_of_week"]).to eq(movie2.days_of_week)
    end
  end

  context "Failure" do

    it "dont should get one movie by id if not exists" do
      movie1 = Movie.create(name: "new movie1", description: "description1", image_url: "url1", days_of_week: "1,3,5")
      get "/api/v1/movies/3"
      body = JSON.parse(last_response.body)
      expect(last_response.status).to eq(404)
    end

    it "dont should create a movie if parameters misisng" do
      params = {description: "description", image_url: "url"}
      count_before = Movie.all.count
      post '/api/v1/movies', params
      body = JSON.parse(last_response.body)
      count_after = Movie.all.count
      expect(count_before).to eq(count_after)
      expect(last_response.status).to eq(400)
      expect(body["error"]).to eq("name is missing, days_of_week is missing")
    end

    it "dont should update a movie if not exists" do
      movie = Movie.create(name: "new movie", description: "description", image_url: "url", days_of_week: "1,3,5")
      params = {name: "name updated", description: "description updated", image_url: "url updated"}
      put "/api/v1/movies/3", params
      body = JSON.parse(last_response.body)
      expect(last_response.status).to eq(404)
    end

    it "dont should delete a movie if not exists" do
      movie = Movie.create(name: "new movie", description: "description", image_url: "url", days_of_week: "1,3,5")
      count_before = Movie.all.count
      delete "/api/v1/movies/3"
      count_after = Movie.all.count
      expect(count_before).to eq(count_after)
      expect(last_response.status).to eq(404)
    end

  end
end