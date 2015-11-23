module Dtu
  class SolrDocument
    include Blacklight::Solr::Document
    include Dtu::SolrDocument::Highlighting
    include Dtu::SolrDocument::Identifiers
  end
end