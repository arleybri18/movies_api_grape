Sequel.migration do
  change do
    create_table(:movies) do
      primary_key :id
      String :name, :null => false
      String :description, :null => false
      String :image_url, :null => false
      String :days_of_week, :null => false

      DateTime :created_at
      DateTime :updated_at
    end
  end
end