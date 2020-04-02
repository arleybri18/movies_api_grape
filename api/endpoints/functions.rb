module Api
  module Endpoints
    class Functions < Grape::API
      include Models
      namespace :functions do
        desc 'create function'
        params do
          requires :date, type: DateTime
          requires :movie_id, type: Integer
          requires :limit, type: Integer
        end
        post do
          movie = Movie.where(:id => params[:movie_id]).first
          if movie
            function = Function.create(date: params[:date].to_datetime, limit: params[:limit], created_at: DateTime.now, updated_at: DateTime.now )
            function.movie = movie
            function.save
            function.values
          else
            status 401
            {status: "parameter not found"}
          end
        end

        desc 'get all of functions',
             is_array: true
        get do
          { :total => Function.count, :data => Function.all.map { |e| { :id => e.id, :date => e.date, :movie => {id: e&.movie&.id, name: e&.movie&.name}, :limit => e.limit} } }
        end

        desc 'get specific function'
        params do
          requires :id
        end
        get ':id' do
          function = Function.where(:id => params[:id]).first
          if function
            { :data => { :id => function.id, :date => function.date, :movie => {id: function.movie.id, name: function.movie.name}, :limit => function.limit } }
          else
            status 404
            {status: "not found"}
          end
        end

        desc 'put specific function'
        params do
          requires :id
          optional :date, type: DateTime
          optional :movie_id, type: Integer
          optional :limit, type: Integer
        end
        put ':id' do
          function = Function.where(:id => params[:id]).first
          if function
            function.update(date: params[:date].to_datetime) if params[:date]
            function.update(limit: params[:limit]) if params[:limit]
            if params[:movie_id]
              movie = Movie.where(:id => params[:movie_id]).first
              if movie
                function.movie = movie
              else
                status 404
                return {status: "movie not found"}
              end
            end
            function.update(updated_at: DateTime.now)
            function.save
            function.values
          else
            status 404
            {status: "not found"}
          end
        end

        desc 'delete specific function'
        params do
          requires :id
        end
        delete ':id' do
          function = Function.where(:id => params[:id]).first
          if function
            function.destroy
            {deleted: true}
          else
            status 404
            {status: "not found"}
          end
        end

        namespace :by_dates do
          desc 'get all bookings from functions by date'
          params do
            requires :date_from, type: DateTime
            requires :date_to, type: DateTime
          end
          get do
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
