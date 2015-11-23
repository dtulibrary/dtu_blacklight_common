module Dtu
  class SolrDocument
    include Blacklight::Solr::Document
    include Dtu::SolrDocument::Highlighting
  end
end