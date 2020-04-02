require 'spec_helper'

RSpec.describe '/api/v1/users' do

  context "Success" do
    it "should get all users" do
      user = User.create(document_id: 123465, name: "new user")
      get '/api/v1/users'
      body = JSON.parse(last_response.body)
      expect(last_response.status).to eq(200)
      expect(body["data"][0]["document_id"]).to eq(user.document_id)
      expect(body["data"][0]["name"]).to eq(user.name)
    end

    it "should get one user by id" do
      user1 = User.create(document_id: 1234567, name: "new user1")
      user2 = User.create(document_id: 1234568, name: "new user2")
      get "/api/v1/users/#{user1.id}"
      body = JSON.parse(last_response.body)
      expect(last_response.status).to eq(200)
      expect(body["data"]["document_id"]).to eq(user1.document_id)
      expect(body["data"]["name"]).to eq(user1.name)

      get "/api/v1/users/#{user2.id}"
      body = JSON.parse(last_response.body)
      expect(last_response.status).to eq(200)
      expect(body["data"]["document_id"]).to eq(user2.document_id)
      expect(body["data"]["name"]).to eq(user2.name)
    end

    it "should create a user" do
      params = {document_id: 1234567, name: "new user"}
      count_before = User.all.count
      post '/api/v1/users', params
      body = JSON.parse(last_response.body)
      count_after = User.all.count
      expect(count_before).to be < count_after
      expect(last_response.status).to eq(201)
      expect(body["document_id"]).to eq(params[:document_id])
      expect(body["name"]).to eq(params[:name])
    end
  end


  context "Failure" do

    it "dont should get one user by id if not exists" do
      user1 = User.create(document_id: 1234567, name: "new user1")
      get "/api/v1/users/3"
      body = JSON.parse(last_response.body)
      expect(last_response.status).to eq(404)
    end

    it "dont should create a user if parameters misisng" do
      params = {name: "new user"}
      count_before = User.all.count
      post '/api/v1/users', params
      body = JSON.parse(last_response.body)
      count_after = User.all.count
      expect(count_before).to eq(count_after)
      expect(last_response.status).to eq(400)
      expect(body["error"]).to eq("document_id is missing")
    end

  end
end
