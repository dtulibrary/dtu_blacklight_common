module Dtu
  class SolrConfigFiles < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)
    def copy_solr_conf_dir
      puts 'Copying solr_conf directory to local app'
      directory 'solr_conf', 'solr_conf'
    end
  end
end