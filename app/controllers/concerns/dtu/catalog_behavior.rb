module Dtu
  module CatalogBehavior
    extend ActiveSupport::Concern
    included do
      include Blacklight::Catalog

      configure_blacklight do |config|

        # items to show per page, each number in the array represent another option to choose from.
        config.per_page = [10,20,50]

        config.solr_path = 'ddf_publ'
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


        config.add_facet_field 'pub_date_tsort', :range => {
            :num_segments => 3,
            :assumed_boundaries => [1900, Time.now.year + 2]
        }
        config.add_facet_field 'author_facet', :limit => 10
        config.add_facet_field 'journal_title_facet', :limit => 10


        # Have BL send all facet field names to Solr, which has been the default
        # previously. Simply remove these lines if you'd rather use Solr request
        # handler defaults, or have no facets.
        config.add_facet_fields_to_solr_request!

        # INDEX FIELDS

        config.add_index_field 'doi_ss'

        # SHOW FIELDS

        config.add_show_field 'subtitle_ts'
        config.add_show_field 'doi_ss'
        config.add_show_field 'abstract_ts'
        config.add_show_field 'isbn_ss'

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