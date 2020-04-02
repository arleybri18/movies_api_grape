Sequel.migration do
  change do
    create_table(:bookings) do
      primary_key :id
      Integer :num_persons, :null => false
      foreign_key :function_id, :functions
      foreign_key :user_id, :users

      DateTime :created_at
      DateTime :updated_at
    end
  end
end