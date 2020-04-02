# frozen_string_literal: true

require 'yaml'
require 'erb'

# load Sequel Configuration
settings = YAML.load_file('config/database.yml')
DB = Sequel.connect(settings[ENV['RACK_ENV']])

env = ENV['RACK_ENV'] || 'development'

logger = if %w[development test].include? env
           log_dir = File.join(Dir.getwd, 'log')
           log_file = File.join(log_dir, 'db.log')
           FileUtils.mkdir(log_dir) unless Dir.exist?(log_dir)
           Logger.new(File.open(log_file, 'a'))
         else
           Logger.new($stdout)
         end

DB.loggers << logger

Sequel::Model.require_valid_table = false
Sequel::Model.plugin :force_encoding, 'UTF-8'
