def app_name_from_environment(env)
  case env.downcase
  when "production"
    "#{Rails.application.class.parent_name.underscore.gsub('_','-')}-production"
  when "staging"
    "#{Rails.application.class.parent_name.underscore.gsub('_','-')}-staging"
  end
end

def push_command_from_env(env)
  case env
  when "production"
    "git push #{env} master"
  when "staging"
    # heroku requires that deployes be pushed to the master branch on heroku git repo
    "git push #{env} staging:master"
  end
end

namespace :heroku_ops do
  desc 'Deploy Safely to Heroku'
  task :deploy do
    env = ENV['ENV']

    abort "Please specify ENV={production|staging}" unless env

    app_name = app_name_from_environment(env)

    #take db backup first
    sh "heroku pg:backups capture --app #{app_name}"

    #push up new code release
    sh push_command_from_env(env)

    #migrate database and ensure seed values are present always (Settings, ContentMgmts)
    sh "heroku run rake db:migrate db:seed --app #{app_name}"

    #restart dynos to ensure all users get the new released version immediately
    sh "heroku restart --app #{app_name}"

    #warm up the Heroku dynos
    sh "curl -o /dev/null http://#{app_name}.herokuapp.com"
  end

  namespace :deploy do
    desc "Deploy to Heroku's Staging Environment"

    desc "Deploy to Heroku's Production Environment"
    task :production do
      ENV['ENV'] = "production"
      sh "git push origin master"
      Rake::Task["heroku_ops:deploy"].invoke
    end

    task :staging do
      ENV['ENV'] = "staging"
      sh "git push origin staging"
      Rake::Task["heroku_ops:deploy"].invoke
    end

    namespace :production do
      desc 'Quick Deploy to Production, without running migrations.'
      task :quick do
        app_name = app_name_from_environment(env)
        Bundler.with_clean_env do
          puts `git push origin master`
          puts `git push production master`
          puts `heroku restart --app app_name`
        end
      end
    end

    namespace :staging do
      desc 'Quick Deploy to Staging, without running migrations.'
      task :quick do
        app_name = app_name_from_environment(env)
        Bundler.with_clean_env do
          puts `git push origin staging`
          puts `git push staging staging:master`
          puts `heroku restart --app app_name`
        end
      end
    end
  end
end
