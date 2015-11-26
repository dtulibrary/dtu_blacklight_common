begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

require 'rdoc/task'
require 'engine_cart/rake_task'
require 'rspec/core/rake_task'
require 'solr_wrapper'
SolrWrapper.default_instance_options[:source_config_dir] = 'lib/generators/dtu/templates/solr_conf'

Dir.glob('lib/tasks/*.rake').each { |r| import r }

RDoc::Task.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'DtuBlacklightCommon'
  rdoc.options << '--line-numbers'
  rdoc.rdoc_files.include('README.rdoc')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

Bundler::GemHelper.install_tasks

task default: :spec
