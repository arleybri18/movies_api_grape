module Api
  module Endpoints
    class Movies < Grape::API
      include Models
      namespace :movies do
        desc 'create movie'
        params do
          requires :name, type: String
          requires :description, type: String
          requires :image_url, type: String
          requires :days_of_week, type: String
        end
        post do
          movie = Movie.create(name: params[:name], description: params[:description], image_url: params[:image_url], days_of_week: params[:days_of_week], created_at: DateTime.now, updated_at: DateTime.now )
          movie.save
          movie.values
        end

        desc 'get all of movies',
             is_array: true
        get do
          { :total => Movie.count, :data => Movie.all.map { |e| { :id => e.id, :name => e.name, :description => e.description, :image_url => e.image_url, :days_of_week => e.days_of_week, functions: e.functions.map {|f| {date: f.date, created_at: f.created_at}}} } }
        end

        desc 'get specific movie'
        params do
          requires :id
        end
        get ':id' do
          movie = Movie.where(:id => params[:id]).first
          if movie
            { :data => { :id => movie.id, :name => movie.name, :description => movie.description, :image_url => movie.image_url, :days_of_week => movie.days_of_week } }
          else
            status 404
            {status: "not found"}
          end
        end

        desc 'put specific movie'
        params do
          requires :id
          optional :name, type: String
          optional :description, type: String
          optional :image_url, type: String
          optional :days_of_week, type: String
        end
        put ':id' do
          movie = Movie.where(:id => params[:id]).first
          if movie
            params.each do |k,v|
              if k.to_sym != :id
                movie.update(k.to_sym => v)
              end
            end
            movie.update(updated_at: DateTime.now)
            movie.save
            movie.values
          else
            status 404
            {status: "not found"}
          end
        end

        desc 'delete specific movie'
        params do
          requires :id
        end
        delete ':id' do
          movie = Movie.where(:id => params[:id]).first
          if movie
            movie.destroy
            {deleted: true}
          else
            status 404
            {status: "not found"}
          end
        end

        namespace :by_day do
          desc 'get list movies by day'
          params do
            requires :day
          end
          get ':day' do
            movies = Movie.where(Sequel.like(:days_of_week, "%#{params[:day]}%"))
            if movies
              { :total => movies.count, :data => movies.map { |e| { :id => e.id, :name => e.name, :description => e.description, :image_url => e.image_url, :days_of_week => e.days_of_week, functions: e.functions.map {|f| {date: f.date, created_at: f.created_at}}} } }
            else
              status 404
              {status: "not found"}
            end
          end
        end
      end
    end
  end
end
