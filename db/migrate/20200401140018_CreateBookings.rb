Sequel.migration do
  change do
    create_table(:bookings) do
      primary_key :id
      Integer :num_persons, :null => false

      DateTime :created_at
      DateTime :updated_at
    end
  end
end