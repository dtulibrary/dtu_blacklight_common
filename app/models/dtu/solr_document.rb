module Dtu
  class SolrDocument
    include Blacklight::Solr::Document
    include Dtu::SolrDocument::Highlighting
    include Dtu::SolrDocument::Identifiers

    def authors_with_affiliations
      contributors_with_affiliations(authors, 'author')
    end

    def editors_with_affiliations
      contributors_with_affiliations(editors, 'editor')
    end

    # Given a group of contributors and a role
    # Return a hash with the contributor and their affiliation index
    # @param contributors Array
    # @param role String author | editor
    # @return Hash e.g. { 'author1' => 3 }
    def contributors_with_affiliations(contributors, role)
      output = {}
      contributors.map.with_index do |cont, i|
        index = affiliation_associations[role][i] || ''
        output[cont] = index
      end
      output
    end

    def authors
      self['author_ts'] || []
    end

    def editors
      self['editor_ts'] || []
    end

    def affiliations
      self['affiliation_ts'] || []
    end

    # Convert the affiliations associations json to a Hash
    def affiliation_associations
      JSON.parse(self['affiliation_associations_json']) || {}
    end
  end
end
