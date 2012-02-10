require 'schreihals/version'

require 'sinatra'
require 'haml'
require 'sass'
require 'redcarpet'
require 'schnitzelstyle'
require 'rack-cache'
require 'coderay'
require 'rack/codehighlighter'
require 'mongoid'

require 'active_support/core_ext/string/inflections'
require 'active_support/core_ext/class'
require 'active_support/concern'

require 'schreihals/static'
require 'schreihals/helpers'
require 'schreihals/post'
require 'schreihals/actions'
require 'schreihals/app'

Sass::Engine::DEFAULT_OPTIONS[:load_paths].unshift(File.expand_path("../views", __FILE__))
Sass::Engine::DEFAULT_OPTIONS[:load_paths].unshift(File.expand_path("./views"))

# configure mongoid
Mongoid.configure do |config|
  Mongoid::Config.from_hash(
    "uri" => ENV['MONGOLAB_URI'] || ENV['MONGOHQ_URL'] || ENV['MONGODB_URL'] || 'mongodb://localhost/schreihals'
  )
end

module Schreihals
end
