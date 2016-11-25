class HerokuOps::Railtie < Rails::Railtie
  rake_tasks do
    load 'tasks/pipeline_setup.rake'
  end
end
