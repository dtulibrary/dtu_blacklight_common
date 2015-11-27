# DtuBlacklightCommon

This gem contains functionality that is shared between Toshokan and DDF. This includes solr configuration, presenter classes and more.

## Installation

Add this line to your application's Gemfile:

    gem 'dtu_blacklight_common', github: 'dtulibrary/dtu_blacklight_common'

And then execute:

    $ bundle install
    
To update your app with references to shared functionality, run: 
    
    $ rails g dtu:install
    
This will update your app's `CatalogController` with a reference to `Dtu::CatalogBehavior`, add routes to your `routes.rb` and include the gem's css file in your `application.css`.
    
## Usage

The functionality provided by this gem assumes that Blacklight has already been installed, it does not run the blacklight installer.

### Dtu::SolrDocument

Make sure your `SolrDocument` model in app/models/solr_document.rb is a subclass of `Dtu::SolrDocument` in order to get those behaviors.

### Initializer

To modify configuration values like pubmed url, create an initializer at config/initializers/dtu_config.rb.  See the [default initializer file](../config/initializers/dtu_config.rb) for reference.

### Solr Config files shared via Generator

This gem holds the 'official' solr config files that are shared between DDF and FindIt. To get the latest copy of these shared solr config files, run this generator in your local app:

    $ rails generate dtu:solr_config_files
    
## Typeahead

This gem includes typeahead functionality for Blacklight, based on the code that is contained in Blacklight 6. As such, this code will need to be removed on upgrading to Blacklight 6. Note though that this feature is not production ready yet.
To enable the typeahead box, you will need to add `//= require dtu/dtu` to your `application.js` and add the following data attributes to the search box in `views/catalog/_search_form.html.erb`:

    data: { autocomplete_enabled: true, autocomplete_path: '/suggest' }
    
You will also need to enable styles for it by adding the following line to your `application.css`:

    *= require 'dtu/_twitter_typeahead'
    
or if you use SASS put this in your `application.scss`:

    @import 'dtu/twitter_typeahead';
    
Note this is dependent on the existence of bootstrap variables within your application and may cause errors if these are not defined.

## Solr

**Note**: this gem is dependent on a forked version of solr_wrapper. Until the [pull request](https://github.com/cbeer/solr_wrapper/pull/17)  has been merged and released, you will need to update your application's Gemfile with: 
    
    gem 'solr_wrapper', github: 'flyingzumwalt/solr_wrapper' 

To do everything with one rake task - install clean copy of solr, configure it and import the data: 
    
    $ rake solr:setup_and_import    
    
To install a clean copy of solr and configure it to have our "toc" and "metadata" collections

    $ rake solr:clean
    $ rake solr:config

To start and stop solr, use

    $ rake solr:start    
    $ rake solr:stop
    
To refresh the configs for the collections (ie. metastore and toc) call this task with solr running:

    $ rake solr:config:collections

## Test Data

To index the test/sample data, run

    $ rake solr:index:all
    
To index only metastore or toc, run `solr:index:metastore` or `solr:index:toc`
    
### Note about Solr config directories

The `solr:config` rake tasks are set up to assume that your configs are in a directory called `solr_conf`.  You can override this by setting `SolrWrapper.default_instance_options[:source_config_dir]`.
For example, the Rakefile in this gem tells SolrWrapper to use the config directories in `lib/generators/dtu/templates/solr_conf`

```ruby
SolrWrapper.default_instance_options[:source_config_dir] = 'lib/generators/dtu/templates/solr_conf'
```

## Metrics

This gem encapsulates common metric helpers, including Altmetric, DTU Orbit, ISI and PubMed. To configure which ones are displayed, use the `config.metrics_presenter_classes` command in `CatalogController`. By default, all metrics presenters will be used, dependent on the type of resource and availability of functional identifiers. 
To enable Altmetric, you will also need to add the following line to the head of your `blacklight.html.erb`:
    
    <%= Dtu::Metrics::AltmetricPresenter.altmetric_embed_script %>
    
This will load the necessary javascript to display the Altmetric badge.

## Test Data

To index the test/sample data, run

    $ rake solr:index:all

## Testing

Install solr, configure it and import the data with one rake task: 
    
    $ rails generate dtu:solr_config_files
    $ rake solr:setup_and_import
    $ rake engine_cart:generate
    $ rspec
