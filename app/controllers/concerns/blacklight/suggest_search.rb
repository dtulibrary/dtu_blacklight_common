# Copied directly from Blacklight master - remove when upgrading to Blacklight 6module Blacklight
module Blacklight
  class SuggestSearch
    attr_reader :request_params, :blacklight_solr

    ##
    # @param [Hash] params
    def initialize(params, blacklight_solr)
      @request_params = { q: params[:q] }
      @blacklight_solr = blacklight_solr
    end

    ##
    # For now, only use the q parameter to create a
    # Blacklight::Suggest::Response
    # @return [Blacklight::Suggest::Response]
    def suggestions
      Blacklight::Suggest::Response.new suggest_results, request_params, suggest_handler_path
    end

    ##
    # Query the suggest handler using RSolr::Client::send_and_receive
    # @return [RSolr::HashWithResponse]
    def suggest_results
      # repository.connection.send_and_receive(suggest_handler_path, params: request_params)
      blacklight_solr.send_and_receive(suggest_handler_path, params: request_params)
    end

    ##
    # @return [String]
    def suggest_handler_path
      # repository.blacklight_config.autocomplete_path
      CatalogController.blacklight_config.autocomplete_path
    end
  end
end