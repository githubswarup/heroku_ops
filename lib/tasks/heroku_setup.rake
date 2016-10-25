def base_app_name
  "#{Rails.application.class.parent_name.parameterize('-')}"
end

def app_name_for_env(env)
  case env.downcase
  when "production"
    "#{base_app_name}-production"
  when "staging"
    "#{base_app_name}-staging"
  end
end

def create_addons_for_appname(appname)
  sh "heroku addons:create heroku-postgresql:hobby-dev -a #{appname}"
  sh "heroku addons:create newrelic:wayne -a #{appname}"
  sh "heroku addons:create papertrail:choklad -a #{appname}"
  sh "heroku addons:create rediscloud:30  -a #{appname}"
  sh "heroku addons:create scheduler:standard -a #{appname}"
  sh "heroku addons:create sendgrid:starter -a #{appname}"
end

namespace :heroku do
  desc 'Setup a heroku app'
  task :setup do
    Rake::Task['heroku:setup:staging'].invoke
    Rake::Task['heroku:setup:production'].invoke
    Rake::Task['heroku:setup:pipeline'].invoke
  end

  namespace :setup do
    desc "Setup a staging app for heroku"
    task :staging do
      app_name = app_name_for_env("staging")
      sh "heroku create #{app_name}"
      create_addons_for_appname(app_name)
    end
    task :production do
      app_name = app_name_for_env("production")
      sh "heroku create #{app_name}"
      create_addons_for_appname(app_name)
    end
    task :pipeline do
      sh "heroku pipelines:create -a#{app_name_for_env("staging")} --stage staging"
      sh "heroku pipelines:add -a#{app_name_for_env("production")} #{base_app_name} --stage production"
    end
  end
end
