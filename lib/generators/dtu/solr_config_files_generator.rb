module Dtu
  class SolrConfigFiles < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)
    def copy_solr_conf_dir
      directory 'solr_conf', 'solr_conf'
    end

    def copy_fixtures
      directory 'fixtures', 'spec/fixtures'
    end

    def copy_solr_yml
      copy_file 'solr.yml', 'config/solr.yml'
    end
  end
end