Upstream
=========
[![Version     ](https://img.shields.io/gem/v/nondestructive_migrations.svg?style=flat)](https://rubygems.org/gems/nondestructive_migrations)
[![Code Climate](https://codeclimate.com/github/jasonfb/nondestructive_migrations/badges/gpa.svg)](https://codeclimate.com/github/jasonfb/nondestructive_migrations)
[![Travis CI](https://travis-ci.org/jasonfb/nondestructive_migrations.svg?branch=master)](https://travis-ci.org/jasonfb/nondestructive_migrations)

Handshake
==========

[![Circle CI](https://circleci.com/gh/strydercorp/nondestructive_migrations.svg?style=svg)](https://circleci.com/gh/strydercorp/nondestructive_migrations)

## About this Fork

This is a fork off of the original repo at https://github.com/jasonfb/nondestructive_migrations

Added to this version are:

1) Add ```disable_ddl_transaction!``` to the template data migration

2) Add a rake task to mark all data migrations as complete, useful for dev environments where the database is dropped from time to time.

3) Logic for announcing to slack when migrations are run, with details.

4) Protections and structure for operating on data carefully.

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
This will create a *schema* migration that will create the data_migrations table itself. (There will be a table in your database called data_migrations which will have two columns: id, version. It works exactly like the schema_migrations table.) Now execute that schema migration (and, in turn, be sure to run this on Production):

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


#

As [![sgringwe](https://github.com/sgringwe)](https://github.com/sgringwe) pointed out to me, by default your data migration will run in a single transaction (just like a schema migration).

To turn this off, add `disable_ddl_transaction!` to the top of your migration, like so:

```
class UpdatePhoneNumbers < ActiveRecord::Migration
  disable_ddl_transaction!
  def up
    # do stuff here
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
```


# Two Kinds of Deployment
You can read more about doing the preboot feature on Heroku at https://devcenter.heroku.com/articles/preboot (Preboot is no longer an "experimental" feature on Heroku.)

## Schema-Change Deploys

1. Switch OFF preboot feature
2. Deploy to Heroku
3. Enable maintenance-mode
4. Run schema migrations  (app reboots)
5. Disable maintenance mode
6. Run the data migrations
7. Switch preboot feature back ON


## Zero-Downtime deploys (no schema migrations)

(assume preboot is already on)
1. Deploy to heroku with preboot on
2. Heroku switches the incoming requests to use the new app
3. Run data migrations (while new app is up & running)

Basically what you want to do is keep Heroku Preboot ON on your app at all times, except when you want to do a schama-change migration. (see https://devcenter.heroku.com/articles/preboot)

The following example assumes your app is named "yourapp-production" and you have a git origin name for heroku (this is what gets configured in .git/config) of "h-prod" that points to your Heroku Git URL for that app.


~/.bash_profile

alias dd-prod="heroku features:disable preboot -a yourapp-production && git checkout master && git pull && git push h-prod master:master && heroku maintenance:on -a yourapp-production && heroku run rake db:migrate -a yourapp-production && heroku maintenance:off -a yourapp-production && heroku run rake data:migrate -a yourapp-production && heroku features:enable preboot -a yourapp-production"

alias ndd-prod="git checkout master && git pull && git push h-prod master:master && heroku run rake data:migrate -a yourapp-production"


Here you can add these as shell scripts (I use bash). dd-prod is my short hand for "destructive deploy to prod." This is what I use when I want to do a schema change migration. Notice that it first disables preboot, expecting it to be on on your Heroku deploy. ndd-prod means "nondestructive deploy to production". Notice that it assumes preboot is already enabled on your Heroku instance and only runs the data migrations. It does not run the schema migrations.

Alternatively, if you don't like the switching preboot off & on part of that, you can deploy a schema-migration code on Heorku and watch the deploy yourself manually. Immediately upon seeing the "Launching..." step, quickly flip your app into maintenance mode with `heroku maintenance:on`

While maintenance is on, run your schema migrations. Restart your app and wait approximately 1-2 minutes, then turn maintenance off. That should avoid the problem of having two apps running at the same time while you're migrating.


## Example App

You can find the app I use to test against here: https://github.com/jasonfb/example-for-nondestructive-migrations

Note the Gemfile has gem pointed with git parameter (directly to this repo). In yours you can omit git parameters to pull the latest release from rubygems. (This repo's master is working development, so it's probably best to use the last released Gem build).

All that is really interesting in that app you will find in db/migrate (the schema migration to create the data migrations table), and db/data_migrate (where those data migrations live).


## Housekeeping
You can run the specs on this gem against Rails 4.1.6 by running
```
rake test TESTOPTS="-v"
```


Or you can run the specs against Rails 4.0.10, and 4.1.6 by using Appraisal (build-in).

```
appraisal rake test
```

Appraisal runs the specs against different versions of Rails. For more information, see https://github.com/thoughtbot/appraisal

You can check out CodeClimate & Travis reports at the top of this README
