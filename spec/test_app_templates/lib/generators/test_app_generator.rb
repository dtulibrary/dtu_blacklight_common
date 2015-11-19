        require 'rails/generators'

        class TestAppGenerator < Rails::Generators::Base
          source_root "./spec/test_app_templates"

          # if you need to generate any additional configuration
          # into the test app, this generator will be run immediately
          # after setting up the application

          def install_blacklight
            say_status('warning', 'GENERATING BLACKLIGHT', :yellow)
            generate 'blacklight:install'
          end

          def install_dtu_common
            generate 'dtu:solr_config_files', '-f'
          end
        end

