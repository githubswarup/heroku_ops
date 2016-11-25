require "heroku_ops/version"
require "heroku_ops/railtie" if defined?(Rails)
require "heroku_rake_deploy" if defined?(Rails)
require "heroku_rake_deploy/railtie" if defined?(Rails)
require "heroku_db_restore" if defined?(Rails)
require "heroku_db_restore/railtie" if defined?(Rails)
module HerokuOps
  # TODO DRY rake tasks by moving repeated code here
end
