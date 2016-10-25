# HerokuOps

A (for now) very opinionated gem which has 3 sections:

* pipeline/app setup
* db restore (pull down your heroku database and `psql < tmp/latest.db`)
* deploys (push to heroku remotes)

These tasks all assume your heroku application names are of the format `"#{Rails.application.class.parent_name.underscore.gsub('_','-')}-#{environment}"`, where environment is one of staging, production. Setting up an app includes the following free Heroku addons:

*heroku-postgresql:hobby-dev
*newrelic:wayne
*papertrail:choklad
*rediscloud:30 
*scheduler:standard
*sendgrid:starter

App name configuration flags and more detailed documentation will come in a later version.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'heroku_ops', group: :development # No need to include this on production or staging
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install heroku_ops

## Usage
To see an updated list of tasks and descriptions:
`bundle exec rake heroku_ops -T heroku_ops`

~~~bash
rake heroku_ops:db:restore                  # Pull Down a copy of the database from the specified heroku environment
rake heroku_ops:db:restore:from_local_dump  # Restore from local dump file (defaults to '/tmp/latest.dump' - specify with DUMP_FILE Environmental Variable)
rake heroku_ops:db:restore:local            # Erase local development and test database and restore from the local dump file
rake heroku_ops:db:restore:production       # Restore a local copy of Heroku's Production Environment database
rake heroku_ops:db:restore:staging          # Restore a local copy of Heroku's Staging Environment database
rake heroku_ops:deploy                      # Deploy Safely to Heroku
rake heroku_ops:deploy:production           # Deploy to Heroku's Production Environment
rake heroku_ops:deploy:production:quick     # Quick Deploy to Production, without running migrations
rake heroku_ops:deploy:staging:quick        # Quick Deploy to Staging, without running migrations
rake heroku_ops:pipeline:setup              # Create a pipeline, staging and production applications
rake heroku_ops:pipeline:setup:pipeline     # Setup a pipeline with your applications in the appropriate stages
rake heroku_ops:pipeline:setup:production   # Setup a production app (with addons) and git remote for heroku
rake heroku_ops:pipeline:setup:staging      # Setup a staging app (with addons) and remote for heroku
~~~


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/nrowegt/heroku_ops.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

Thanks to [@danielricecodes](http://www.ldstudios.co/) for the inspiration and the initial base implementations of the restore and deploy tasks.

