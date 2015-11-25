# Copied directly from Blacklight master - remove when upgrading to Blacklight 6module Blacklight
module Blacklight
  module Suggest
    class Response
      attr_reader :response, :request_params, :suggest_path

      ##
      # Creates a suggest response
      # @param [RSolr::HashWithResponse] response
      # @param [Hash] request_params
      # @param [String] suggest_path
      def initialize(response, request_params, suggest_path)
        @response = response
        @request_params = request_params
        @suggest_path = suggest_path
      end

      ##
      # Trys the suggestor response to return suggestions if they are
      # present
      # @return [Array]
      def suggestions
        # response.try(:[], suggest_path).try(:[], 'mySuggester').try(:[], request_params[:q]).try(:[], 'suggestions') || []
        # this has been changed a bit since we're not using the default request handler naming and our solr url is
        # a little different than they seem to expect here
        response.try(:[], 'suggest').try(:[], 'completions').try(:[], request_params[:q]).try(:[], 'suggestions') || []
      end
    end
  end
end