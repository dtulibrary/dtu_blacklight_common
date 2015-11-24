# -*- encoding : utf-8 -*-
class CatalogController < ApplicationController

  include Dtu::CatalogBehavior

  # Declare Facet, Index and Show fields for use in tests
  # These can't be declared by Dtu::CatalogBehavior because ordering is relevant
  # -- we want the host apps to be able to control the order of these fields.
  configure_blacklight do |config|

    ##
    # FACET FIELDS
    config.add_facet_field 'pub_date_tsort', :range => {
                                               :num_segments => 3,
                                               :assumed_boundaries => [1900, Time.now.year + 2]
                                           }
    config.add_facet_field 'author_facet', :limit => 10
    config.add_facet_field 'journal_title_facet', :limit => 10

    ##
    # INDEX FIELDS
    config.add_index_field 'doi_ss'

    ##
    # SHOW FIELDS
    config.add_show_field 'subtitle_ts'
    config.add_show_field 'doi_ss'
    config.add_show_field 'abstract_ts'
    config.add_show_field 'isbn_ss'
  end
end