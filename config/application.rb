require 'rubygems'
require 'bundler/setup'
require_relative 'environment'

Bundler.require :default, ENV['RACK_ENV']

# load config files
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'api'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

Dir[File.expand_path('../config/initializers/*.rb', __dir__)].sort.each do |initializer|
  require initializer
end

Dir[File.expand_path('../lib/**/*.rb', __dir__)].sort.each do |lib|
  require lib
end

Dir[File.expand_path('../api/endpoints/*.rb', __dir__)].sort.each do |endpoint|
  require endpoint
end

#require base endpoint
require 'base'

class App
  def initialize
    @apps = {}
  end

  def call(env)
    if Api::Base.recognize_path(env['REQUEST_PATH'])
      Api::Base.call(env)
    else
      [403, { 'Content-Type': 'text/plain' }, ['403 Forbidden']]
    end
  end
end