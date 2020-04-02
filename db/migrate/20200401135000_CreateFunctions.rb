Sequel.migration do
  change do
    create_table(:functions) do
      primary_key :id
      DateTime :date, :null => false
      Integer :limit, :null => false
      foreign_key :movie_id, :movies

      DateTime :created_at
      DateTime :updated_at
    end
  end
end