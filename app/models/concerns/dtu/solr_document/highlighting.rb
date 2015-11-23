module Dtu
  class SolrDocument
    module Highlighting
      extend ActiveSupport::Concern
      included do

        # OVERRIDES Blacklight::Solr::Document.has_highlight_field?
        # Why are we overriding this? The official implementation of this method looks in response['highlighting'][self.id]
        # we need it to look in response['highlighting'][self['id']] instead.
        # Why doesn't self['id'] == self.id ? Because SolrDocument.unique_key is 'cluster_id_ss'
        # but documents in solr have a separate 'id' field with a different value.  This is an artifact
        # from when we stored multiple documents in solr with the same 'cluster_id_ss' but needed Blacklight
        # to display that information as a single document with the cluster_id_ss as its identifier.
        # Now that we only index one document per cluster_id_ss, A more permanent fix would be to index documents
        # using cluster_id_ss as the solr_doc['id']
        def has_highlight_field? k
          return false if response['highlighting'].blank? or response['highlighting'][self['id']].blank?

          response['highlighting'][self['id']].key? k.to_s
        end

        # OVERRIDES Blacklight::Solr::Document.highlight_field
        # @see has_highlight_field?
        def highlight_field k
          response['highlighting'][self['id']][k.to_s].map(&:html_safe) if has_highlight_field? k
        end

        # forward-compatibility.
        # TODO: Remove this when you upgrade to blacklight 6
        def response
          @solr_response
        end
      end
    end
  end
end
