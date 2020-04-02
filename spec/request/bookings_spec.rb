require 'spec_helper'

RSpec.describe '/api/v1/bookings' do

  context "Success" do
    it "should get all bookings" do
      movie = Movie.create(name: "new movie", description: "description", image_url: "url", days_of_week: "1,3,5")
      function = Function.create(date: DateTime.now, movie: movie, limit: 10)
      user = User.create(document_id: 123456, name: "New user")
      booking = Booking.create(function: function, user: user, num_persons: 2)
      get '/api/v1/bookings'
      body = JSON.parse(last_response.body)
      expect(last_response.status).to eq(200)
      expect(body["data"][0]["user"]["name"]).to eq(user.name)
      expect(body["data"][0]["function"]["movie"]).to eq(movie.name)
      expect(body["data"][0]["num_persons"]).to eq(booking.num_persons)
    end

    it "should get one booking by id" do
      movie = Movie.create(name: "new movie1", description: "description1", image_url: "url1", days_of_week: "1,3,5")
      function = Function.create(date: DateTime.now, movie: movie, limit: 10)
      user = User.create(document_id: 123456, name: "New user")
      booking1 = Booking.create(function: function, user: user, num_persons: 2)
      booking2 = Booking.create(function: function, user: user, num_persons: 5)
      get "/api/v1/bookings/#{booking1.id}"
      body = JSON.parse(last_response.body)
      expect(last_response.status).to eq(200)
      expect(body["data"]["user"]["name"]).to eq(user.name)
      expect(body["data"]["function"]["movie"]).to eq(movie.name)
      expect(body["data"]["num_persons"]).to eq(booking1.num_persons)

      get "/api/v1/bookings/#{booking2.id}"
      body = JSON.parse(last_response.body)
      expect(last_response.status).to eq(200)
      expect(body["data"]["user"]["name"]).to eq(user.name)
      expect(body["data"]["function"]["movie"]).to eq(movie.name)
      expect(body["data"]["num_persons"]).to eq(booking2.num_persons)
    end

    it "should create a booking" do
      movie = Movie.create(name: "new movie1", description: "description1", image_url: "url1", days_of_week: "1,3,5")
      function = Function.create(date: DateTime.now, movie: movie, limit: 10)
      user = User.create(document_id: 123456, name: "New user")
      params = {function_id: function.id, document_id: user.document_id, num_persons: 2}
      count_before = Booking.all.count
      post '/api/v1/bookings', params
      body = JSON.parse(last_response.body)
      count_after = Booking.all.count
      expect(count_before).to be < count_after
      expect(last_response.status).to eq(201)
      expect(body["user_id"]).to eq(user.id)
      expect(body["function_id"]).to eq(function.id)
      expect(body["num_persons"]).to eq(params[:num_persons])
    end


    it "should delete a booking" do
      movie = Movie.create(name: "new movie1", description: "description1", image_url: "url1", days_of_week: "1,3,5")
      function = Function.create(date: DateTime.now, movie: movie, limit: 10)
      user = User.create(document_id: 123456, name: "New user")
      booking = Booking.create(function: function, user: user, num_persons: 2)
      count_before = Booking.all.count
      delete "/api/v1/bookings/#{booking.id}"
      count_after = Booking.all.count
      expect(count_before).to be > count_after
      expect(last_response.status).to eq(200)
    end

  end

  context "Failure" do

    it "dont should get one booking by id if not exists" do
      movie = Movie.create(name: "new movie1", description: "description1", image_url: "url1", days_of_week: "1,3,5")
      function = Function.create(date: DateTime.now, movie: movie, limit: 10)
      user = User.create(document_id: 123456, name: "New user")
      booking = Booking.create(function: function, user: user, num_persons: 2)
      get "/api/v1/bookings/3"
      body = JSON.parse(last_response.body)
      expect(last_response.status).to eq(404)
    end

    it "dont should create a booking if parameters misisng" do
      movie = Movie.create(name: "new movie1", description: "description1", image_url: "url1", days_of_week: "1,3,5")
      function = Function.create(date: DateTime.now, movie: movie, limit: 10)
      user = User.create(document_id: 123456, name: "New user")
      params = {document_id: user.document_id, num_persons: 2}
      count_before = Booking.all.count
      post '/api/v1/bookings', params
      body = JSON.parse(last_response.body)
      count_after = Booking.all.count
      expect(count_before).to eq(count_after)
      expect(last_response.status).to eq(400)
      expect(body["error"]).to eq("function_id is missing")
    end

    it "dont should create a booking if limit of function if passed" do
      movie = Movie.create(name: "new movie1", description: "description1", image_url: "url1", days_of_week: "1,3,5")
      function = Function.create(date: DateTime.now, movie: movie, limit: 10)
      user = User.create(document_id: 123456, name: "New user")
      booking = Booking.create(function: function, user: user, num_persons: 10)
      params = {function_id: function.id, document_id: user.document_id, num_persons: 2}
      count_before = Booking.all.count
      post '/api/v1/bookings', params
      body = JSON.parse(last_response.body)
      count_after = Booking.all.count
      expect(count_before).to eq(count_after)
      expect(last_response.status).to eq(401)
      expect(body["error"]).to eq("The number of people exceeds the available limit of the function")
    end

    it "dont should delete a booking if not exists" do
      movie = Movie.create(name: "new movie1", description: "description1", image_url: "url1", days_of_week: "1,3,5")
      function = Function.create(date: DateTime.now, movie: movie, limit: 10)
      user = User.create(document_id: 123456, name: "New user")
      booking = Booking.create(function: function, user: user, num_persons: 2)
      count_before = Booking.all.count
      delete "/api/v1/bookings/3"
      count_after = Booking.all.count
      expect(count_before).to eq(count_after)
      expect(last_response.status).to eq(404)
    end
  end
end