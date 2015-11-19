# DtuBlacklightCommon

This gem contains functionality that is shared between Toshokan and DDF. This includes solr configuration, presenter classes and more.

## Installation

Add this line to your application's Gemfile:

    gem 'dtu_blacklight_common', github: 'dtulibrary/dtu_blacklight_common'

And then execute:

    $ bundle install

Then:

    $ rails generate dtu_blacklight_common:install
    $ rake db:migrate

## Usage

### Generator

To copy the shared solr config files to your local app, run:

    $ rails generate dtu:solr_config_files
    
Note that this gem is dependent on a forked version of solr_wrapper. Until the [pull request](https://github.com/cbeer/solr_wrapper/pull/14)  has been merged and released, you will need to update your application's Gemfile with: 
    
    gem 'solr_wrapper', github: 'flyingzumwalt/solr_wrapper' 
    
## Solr

Install a clean copy of solr and configure it to have our "toc" and "metadata" collections

    $ rake solr:clean
    $ rake solr:config

To start and stop solr, use

    $ rake solr:start    
    $ rake solr:stop
    
To refresh the configs for the collections (ie. metastore and toc) call this task with solr running:

    $ rake solr:config_collections
    $ rake solr:import

Calling config_collections deletes the cores and re-creates them so you have to re-import the data after refreshign the configs.

## Test Data

To index the test/sample data, run

    $ rake solr:index:all

## Testing

Install solr, configure it and import the data with one rake task: 
    
    $ rails generate dtu:solr_config_files
    $ rake solr:setup_and_import
    $ rake engine_cart:generate
    $ rspec
