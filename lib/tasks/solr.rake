require 'solr_wrapper/rake_task'
namespace :solr do

  def source_config_dir
    @source_config_dir ||= SolrWrapper.default_instance_options.has_key?(:source_config_dir) ? SolrWrapper.default_instance_options[:source_config_dir] : 'solr_conf'
  end

  task :environment do
    solr_defaults = {
        verbose: true,
        cloud: true,
        port: '8983',
        version: '5.3.1',
        instance_dir: 'solr',
        source_config_dir: source_config_dir,
        extra_lib_dir: File.join(source_config_dir,'lib'),
    }
    solr_defaults.each_pair do |key, value|
      SolrWrapper.default_instance_options[key] ||= value
    end
    SolrWrapper.default_instance_options[:download_dir] ||= Rails.root.to_s + '/tmp' if defined? Rails
    # Delete the default_instance created by the solr:environment task from solr_wrapper
    # so that the new defaults will be used when you call SolrWrapper.default_instance
    SolrWrapper.remove_instance_variable(:@default_instance)
    @solr_instance = SolrWrapper.default_instance
  end

  desc 'Set up a clean solr, configure it and import sample data'
  task :setup_and_import => :environment do
    Rake::Task["solr:clean"].execute
    Rake::Task["solr:config"].execute
    Rake::Task["solr:import:metastore"].execute
    Rake::Task["solr:import:toc"].execute
  end

  desc 'Run all solr config tasks (invokes solr:config:all)'
  task :config do
    Rake::Task['solr:config:all'].invoke
  end

  namespace :config do

    desc 'Configure solr with toc and metastore collections'
    task :all => :environment do
      Rake::Task["solr:config:instance"].execute
      puts "   starting solr to set up collections"
      Rake::Task["solr:start"].execute
      Rake::Task["solr:config:collections"].execute
    end

    desc 'Run the solr_instance configure method (copies lib directories etc).'
    task :instance => :environment do
      puts "Stopping solr before configuring"
      Rake::Task["solr:stop"].execute
      puts "Configuring solr at #{File.expand_path(@solr_instance.instance_dir)}"
      @solr_instance.configure
    end

    desc 'Configure metastore and toc collections in the solr cloud'
    task :collections => :environment do
      puts "   creating/updating metastore collection"
      @solr_instance.create_or_reload('metastore', dir:"#{source_config_dir}/metastore/conf")
      puts "   creating/updating toc collection"
      @solr_instance.create_or_reload('toc', dir:"#{source_config_dir}/toc/conf")
      puts "finished configuring. Solr is running."
    end
  end

  desc "Import all sample data into solr (invokes solr:import:all)"
  task :import do
    Rake::Task['solr:import:all'].invoke
  end

  namespace :import do
    desc "Import all sample data into solr"
    task :all => [:metastore, :toc]

    desc "Import metastore sample data"
    task :metastore => :environment do
      puts "Importing metastore sample data"
      post_solr_data(@solr_instance, 'metastore', 'spec/fixtures/solr_data.xml')
    end

    desc "Import toc sample data"
    task :toc => :environment do
      puts "Importing toc sample data"
      post_solr_data(@solr_instance, 'toc', 'spec/fixtures/toc_data.xml')
    end
  end

  # Post the data from +path_to_data+ to collection +collection_name+ in +solr_instance+
  def post_solr_data(solr_instance, collection_name, path_to_data)
    result = %x{curl '#{solr_instance.url}#{collection_name}/update?commit=true&wt=json' -d @#{path_to_data}}
    begin
      json = JSON.parse(result)
      if json['responseHeader']['status'] == 0
        puts "   import successful"
      else
        puts result
      end
    rescue
      puts result
    end
  end

end
