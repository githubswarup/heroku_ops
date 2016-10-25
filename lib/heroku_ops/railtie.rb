class HerokuOps::Railtie < Rails::Railtie
  rake_tasks do
    load 'tasks/pipeline_setup.rake'
    load 'tasks/deploy.rake'
    load 'tasks/db_restore.rake'
  end
end
