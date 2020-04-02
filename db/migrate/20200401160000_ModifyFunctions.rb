Sequel.migration do
  change do
    alter_table(:functions) do
      add_foreign_key :movie_id, :movies
    end
  end
end