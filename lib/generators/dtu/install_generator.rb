module Dtu
  class InstallGenerator < Rails::Generators::Base
    def update_catalog_controller
      gsub_file 'app/controllers/catalog_controller.rb', 'include Blacklight::Catalog', 'include Dtu::CatalogBehavior'
    end

    def inject_routes
      inject_into_file 'config/routes.rb', after: "Rails.application.routes.draw do\n" do
        "  mount DtuBlacklightCommon::Engine, at: '/'\n"\
      end
    end
  end
end