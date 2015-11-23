module Dtu
  class SolrDocument
    module Identifiers

      def recognized_identifiers
        identifiers = {}
        identifiers[:doi]    = self[:doi_ss].try(:first)
        identifiers[:issn]   = self[:issn_ss].try(:first)
        identifiers[:isbn]   = self[:isbn_ss].try(:first)
        identifiers[:scopus] = get_source_id(:scopus)
        identifiers[:pmid]   = get_source_id(:pubmed)
        identifiers[:arxiv]  = get_source_id(:arxiv)
        identifiers.delete_if{ |k, v| v.blank? }
      end

      def get_source_id(source)
        self[:source_id_ss].find{|id| id.start_with?(source.to_s)}.try(:split, ':').try(:last)
      end

    end
  end
end
