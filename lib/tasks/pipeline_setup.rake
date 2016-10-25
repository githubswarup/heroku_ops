def base_app_name
  "#{Rails.application.class.parent_name.underscore.gsub('_','-')}"
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

def create_remote_for_appname(env, appname)
  sh "git remote add #{env} git@heroku.com:#{appname}.git"
end

namespace :heroku_ops do
  namespace :pipeline do
    desc 'Create a pipeline, staging and production applications.'
    task :setup do
      Rake::Task['heroku_ops:pipeline:setup:staging'].invoke
      Rake::Task['heroku_ops:pipeline:setup:production'].invoke
      Rake::Task['heroku_ops:pipeline:setup:pipeline'].invoke
    end

    namespace :setup do
      desc "Setup a staging app (with addons) and remote for heroku"
      task :staging do
        app_name = app_name_for_env("staging")
        sh "heroku create #{app_name}"
        sh "git remote remove heroku"        
        create_addons_for_appname(app_name)
        create_remote_for_appname("staging", app_name)
      end
      desc "Setup a production app (with addons) and git remote for heroku"      
      task :production do
        app_name = app_name_for_env("production")
        sh "heroku create #{app_name}"
        sh "git remote remove heroku"        
        create_addons_for_appname(app_name)
        create_remote_for_appname("production", app_name)
      end
      desc "Setup a pipeline with your applications in the appropriate stages."
      task :pipeline do
        sh "heroku pipelines:create -a#{app_name_for_env("staging")} --stage staging"
        sh "heroku pipelines:add -a#{app_name_for_env("production")} #{base_app_name} --stage production"
      end
    end
  end
end
