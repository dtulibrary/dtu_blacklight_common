module Dtu
  class InstallGenerator < Rails::Generators::Base
    def update_catalog_controller
      # gsub_file 'app/controllers/catalog_controller.rb', 'include Blacklight::Catalog', 'include Dtu::CatalogBehavior'
    end

    def inject_routes
      inject_into_file 'config/routes.rb', after: "Rails.application.routes.draw do\n" do
        "  mount DtuBlacklightCommon::Engine, at: '/'\n"\
      end
    end

    def add_css
      if File.exists?("app/assets/stylesheets/application.css")
        inject_into_file 'app/assets/stylesheets/application.css', after: "*= require_self\n" do
          " *= require 'dtu/dtu'\n"
        end
      elsif File.exists?("app/assets/stylesheets/application.scss")
        append_to_file 'app/assets/stylesheets/application.scss' do
          "@import 'dtu/twitter_typeahead';\n"
        end
      end
    end

    def add_javascript
      # we're commenting this out at present because the typeahead feature isn't working properly
      # inject_into_file 'app/assets/javascripts/application.js', after: "//= require blacklight/blacklight\n" do
      #   "//= require dtu/dtu\n"
      # end
    end
  end
end