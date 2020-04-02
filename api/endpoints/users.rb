module Api
  module Endpoints
    class Users < Grape::API
      include Models
      namespace :users do
        desc 'create user'
        params do
          requires :document_id, type: String
          requires :name, type: String
        end
        post do
          begin
          user = User.create(document_id: params[:document_id], name: params[:name], created_at: DateTime.now, updated_at: DateTime.now )
          user.save
          user.values
          rescue StandardError => e
            status 401
            {error: e.message}
          end
        end

        desc 'get all of users',
             is_array: true
        get do
          { :total => User.count, :data => User.all.map { |e| {:id => e.id, :document_id => e.document_id, :name => e.name} } }
        end

        desc 'get specific user'
        params do
          requires :id
        end
        get ':id' do
          user = User.where(:id => params[:id]).first
          if user
            { :data => { :id => user.id, :document_id => user.document_id, :name => user.name } }
          else
            status 404
            {status: "not found"}
          end
        end
      end
    end
  end
end
