class HerokuPipeline::Railtie < Rails::Railtie
  rake_tasks do
    load 'tasks/pipeline/setup.rake'
    load 'tasks/deploy.rake'
  end
end
