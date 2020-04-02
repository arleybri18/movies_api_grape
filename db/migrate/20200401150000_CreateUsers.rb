Sequel.migration do
  change do
    create_table(:users) do
      primary_key :id
      Integer :document_id, unique: true
      String :name

      DateTime :created_at
      DateTime :updated_at
    end
  end
end