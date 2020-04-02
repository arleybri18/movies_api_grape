Sequel.migration do
  change do
    alter_table(:bookings) do
      add_foreign_key :function_id, :functions
      add_foreign_key :user_id, :users
    end
  end
end