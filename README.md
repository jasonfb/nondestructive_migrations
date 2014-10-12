[![Version     ](https://img.shields.io/gem/v/nondestructive_migrations.svg?style=flat)](https://rubygems.org/gems/nondestructive_migrations)
[![Code Climate](https://codeclimate.com/github/jasonfb/nondestructive_migrations/badges/gpa.svg)](https://codeclimate.com/github/jasonfb/nondestructive_migrations)
[![Travis CI](https://travis-ci.org/jasonfb/nondestructive_migrations.svg?branch=master)](https://travis-ci.org/jasonfb/nondestructive_migrations)


## Introduction

Nondestructive migrations, also known as data migrations, are a alternative kind of Rails migration. The data migrations operate exactly like schema migrations, except instead of running migrations to make changes to your schema (adding fields, dropping fields, adding tables, etc), you run data migrations to manipulate data in your app, enqueue or execute Resque jobs that require long-running processes. This happens in a Rails app for different reasons, usually to clean up or supplement data or architectural changes.

Splitting your data migrations from your schema migrations has a particular benefit of achieving the most consistent zero-downtime deploys you can. I recommend you switch your deployment script to allow you to do two types of deploys: a Zero-downtime deploy (no schema migrations) and Schema Migration deploy. 

This way, you can deploy any non-destructive (data-only) migration with a Zero-downtime strategy, and opt to make destructive (schema) migrations in a normal deployment (maintenance on, run schema changes, boot up new app,  maintenance off).  Data-only migrations can be run while the app is actually running, augmenting what you can achieve with the migration-style shortcuts provided by Rails.

A word of caution: If you find yourself making a lot of data migrations, you might consider if your product/development/business process is too reliant on one-off data importing. It may be that data management tools will help you in the long run. Nonetheless, separating your schema migrations from your data migrations can be a great strategy for modern Rails development.

Data migrations functional EXACTLY like schema migrations except:

1) They live in db/data_migrate instead of db/migrate

2) They timestamps used to record which ones have been run are in a table called data_migrations instead of the normal schema_migrations table

3) You run them using rake data:migrate instead of rake db:migrate

## Installation
To add to your Rails project, follow these steps.

1) Add this to your gemfile.
```ruby
gem 'nondestructive_migrations'
```

2) Run `bundle install

3) Run the setup script:
```
rails generate data_migrations:install
```
This will create a *schema* migration that will create the data_migrations table itself. Now execute that schema migration:

```
rake db:migrate
```

You are now set up and ready to start making data migrations. To create your first migration, create it with a generating using a camal-case description of what your data migration does. 

```
rails generate data_migration UpdatePhoneNumbers
```

Look for a file called (something like) `db/data_migrate/20140831020834_update_phone_numbers.rb`. It will have been automatically written with an empty up and down method. Add whatever operations you want to do in your **up** method, like large data manipulation jobs, running rake tasks, or enqueuing batch process jobs. 

You probably want to put `ActiveRecord::IrreversibleMigration` into the **down** method your data migration:

```
class UpdatePhoneNumbers < ActiveRecord::Migration
  def up
    # do stuff here
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
```

To actually tell your app to run the data migration, use:

```
rake data:migrate
```


You get three additional rake tasks that operate and have the same syntax as the schema migrations, but operate only on the data migrations. 

## rake data:migrate
Migrate all data migrations that haven't been migrated.

## rake data:migrate:down VERSION=xxxxxxxxxxx
Migrate down the specified version

## rake data:migrate:up VERSION=xxxxxxxxxxx
Migrate up the specified versions.

## rake data:rollback
Rollback the last version. Generally data migrations don't have any "down" associated with them so use this only under extreme circumstances. 


# Two Kinds of Deployment
You can read more about doing the preboot feature on Heroku labs at https://devcenter.heroku.com/articles/labs-preboot. (Preboot is an "experimental" feature on Heroku.)

## Schema-Change Deploys

1. Compile the assets
2. Enable maintenance-mode
3. Launch the new app
4. Run schema migrations
5. Reboot the app (force Rails to pick up new schema changes)
6. Disable maintenance mode


## Zero-Downtime deploys (no schema migrations)

1. Compile the assets
2. Pre-boot the new app
3. Heroku switches the incoming requests to use the new app
4. Run data migrations (while new app is up & running)


## Housekeeping
You can run the specs on this gem against Rails 4.1.6 by running
```
rake test TESTOPTS="-v"
```


Or you can run the specs against Rails 3.2.19, 4.0.10, and 4.1.6 by using Appraisal (build-in).

```
appraisal rake test
```

Appraisal runs the specs against different versions of Rails. For more information, see https://github.com/thoughtbot/appraisal

You can check out CodeClimate & Travis reports at the top of this README
