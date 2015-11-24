module Dtu
  # Includes BlacklightCatalog and provides common Dtu configuration
  # You must declare your own index, facet, and show fields in the host class (ie. CatalogController)
  # because ordering is relevant when you call `add_index_field`, `add_facet_field` and `add_show_field`
  # For examples of how to use those methods, see Blacklight's default CatalogController or see
  # dtu_blacklight_common/spec/test_app_templates/catalog_controller.rb
  module CatalogBehavior
    extend ActiveSupport::Concern
    included do
      include Blacklight::Catalog

      configure_blacklight do |config|
        # Ensure I18n load paths are loaded
        Dir[Rails.root + 'config/locales/**/*.{rb,yml}'].each { |path| I18n.load_path << path }

        # items to show per page, each number in the array represent another option to choose from.
        config.per_page = [10,20,50]

        config.solr_path = 'ddf_publ'
        config.document_presenter_class = Dtu::DocumentPresenter
        config.default_solr_params = {
            :q => '*:*',
            :rows => 10,
            :hl => true,
            'hl.snippets' => 3,
            'hl.usePhraseHighlighter' => true,
            'hl.fl' => 'title_ts, author_ts, journal_title_ts, conf_title_ts, abstract_ts, publisher_ts',
            'hl.fragsize' => 300
        }


        config.index.title_field = 'title_ts'
        # solr field configuration for document/show views
        config.show.title_field = 'title_ts'

        # Have BL send all facet field names to Solr, which has been the default
        # previously. Simply remove these lines if you'd rather use Solr request
        # handler defaults, or have no facets.
        config.add_facet_fields_to_solr_request!

        # SORTING

        relevance_ordering = [
            'score desc',
            'pub_date_tsort desc',
            'journal_vol_tsort desc',
            'journal_issue_tsort desc',
            'journal_page_start_tsort asc',
            'title_sort asc'
        ]
        config.add_sort_field relevance_ordering.join(', '), :label => 'relevance'

        year_ordering = [
            'pub_date_tsort desc',
            'journal_vol_tsort desc',
            'journal_issue_tsort desc',
            'journal_page_start_tsort asc',
            'title_sort asc'
        ]
        config.add_sort_field year_ordering.join(', '), :label => 'year'

        title_ordering = [
            'title_sort asc',
            'pub_date_tsort desc'
        ]
        config.add_sort_field title_ordering.join(', '), :label => 'title'
      end
    end
  end
end