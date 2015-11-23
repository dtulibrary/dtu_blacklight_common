module Dtu
  class InstallGenerator < Rails::Generators::Base
    def update_catalog_controller
      gsub_file 'app/controllers/catalog_controller.rb', 'include Blacklight::Catalog', 'include Dtu::CatalogBehavior'
    end
  end
end