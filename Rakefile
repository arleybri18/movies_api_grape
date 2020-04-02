require 'rake'

require File.expand_path('config/application', __dir__)

task :environment do
  ENV['RACK_ENV'] ||= 'development'
end

# rspec tasks
require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

# Sequel migration tasks
namespace :db do
  require "sequel"
  Sequel.extension(:migration)

  desc "Prints current schema version"
  task version: :connect do
    version = DB.tables.include?(:schema_info) ? DB[:schema_info].first[:version] : 0

    $stdout.print 'Schema Version: '
    $stdout.puts version
  end

  desc 'Run all migrate in db/migrate'
  task migrate: :connect do
    Sequel::Migrator.run(DB, 'db/migrate')
    Rake::Task['db:version'].execute
  end

  desc "Perform rollback to specified target or full rollback as default"
  task :rollback, [:target] => :connect do |t, args|
    args.with_defaults(:target => 0)

    Sequel::Migrator.run(DB, 'db/migrate', :target => args[:target].to_i)
    Rake::Task['db:version'].execute
  end

  desc "Perform migration reset (full rollback and migration)"
  task reset: :connect do
    Sequel::Migrator.run(DB, 'db/migrate', target: 0)
    Sequel::Migrator.run(DB, 'db/migrate')
    Rake::Task['db:version'].execute
  end

  task connect: :environment do
    require './config/initializers/database'
  end
end
