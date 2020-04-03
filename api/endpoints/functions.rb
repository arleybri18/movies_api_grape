module Api
  module Endpoints
    class Functions < Grape::API
      include Models

      namespace :functions do

        namespace :by_dates do
          desc 'get all bookings from functions by date'
          get do
            date_from = params[:date_from].to_datetime
            date_to = params[:date_to].to_datetime
            functions = Function.where(date: (date_from)..(date_to)) if date_from && date_to
            if functions
              data = functions.map do |f|
                {
                    function_id: f.id, function_date: f.date, movie: f.movie.name,
                    bookings: f.bookings.map {|b| {id: b.id, num_persons: b.num_persons, user_id: b.user.document_id}}
                }
              end
              { :total => functions.count, :data => data}

            else
              {message: "not data found"}
            end
          end
        end


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
      end
    end
  end
end
