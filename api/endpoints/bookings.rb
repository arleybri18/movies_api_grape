module Api
  module Endpoints
    class Bookings < Grape::API
      include Models
      namespace :bookings do
        desc 'create booking'
        params do
          requires :function_id
          requires :document_id
          requires :num_persons
        end
        post do
          function = Function.where(:id => params[:function_id]).first
          user = User.where(:document_id => params[:document_id]).first
          if (function&.ocupation + params[:num_persons].to_i) > function&.limit
            status 401
            return {error: "The number of people exceeds the available limit of the function"}
          end
          if function && user
            booking = Booking.create(function: function, user: user, num_persons: params[:num_persons], created_at: DateTime.now, updated_at: DateTime.now )
            booking.save
            booking.values
          else
            status 404
            {status: "parameters not found"}
          end
        end

        desc 'get all of bookings',
             is_array: true
        get do
          { :total => Booking.count, :data => Booking.all.map { |e| { :id => e.id, :user => {:id => e.user.id, :name => e.user.name },:function => {:id => e.function.id, :date => e.function.date, :movie => e.function.movie.name}, :num_persons => e.num_persons} } }
        end

        desc 'get specific booking'
        params do
          requires :id
        end
        get ':id' do
          booking = Booking.where(:id => params[:id]).first
          if booking

            { :data => { :id => booking.id, :user => {:id => booking.user.id, :name => booking.user.name },:function => {:id => booking.function.id, :date => booking.function.date, :movie => booking.function.movie.name}, :num_persons => booking.num_persons} }
          else
            status 404
            {status: "not found"}
          end
        end

        desc 'delete specific booking'
        params do
          requires :id
        end
        delete ':id' do
          booking = Booking.where(:id => params[:id]).first
          if booking
            booking.destroy
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
