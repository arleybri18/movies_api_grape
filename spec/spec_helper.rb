ENV['RACK_ENV'] = 'test'

require 'rack/test'
require File.expand_path('../config/application', __dir__)
include Models

RSpec.configure do |config|
  include Rack::Test::Methods

  config.before(:suite) do
    Sequel.extension :migration
    DB.tables.each do |table|
      DB.drop_table(table.to_sym)
    end
    Sequel::Migrator.run(DB, 'db/migrate')
    DB.tables.each do |table|
      DB[table.to_sym].truncate
    end
  end
  config.around(:each) do |example|
    DB.transaction(:rollback=>:always, :auto_savepoint=>true){example.run}
  end

  config.color = true
  config.formatter = :documentation

  config.mock_with :rspec
  config.expect_with :rspec

  config.raise_errors_for_deprecations!
end

def app
  Api::Base
end