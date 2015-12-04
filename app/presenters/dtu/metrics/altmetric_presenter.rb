module Dtu
  module Metrics
    class AltmetricPresenter < Dtu::Presenter
      presents :document

      def should_render?
        recognized_identifiers? && current?
      end

      def render(opts={})
        altmetric_badge(opts)
      end

      def altmetric_badge(opts={})
        content_tag :div, class:'altmetric-wrapper' do
          identifiers = document.recognized_identifiers
          tag_attributes = {
              class:'altmetric-embed',
              "data-badge-type"=>'donut',
              "data-badge-popover"=>'left',
              'data-hide-no-mentions' => 'true',
              'data-link-target' => '_blank'
            }
          ["data-badge-type", "data-badge-popover", :class].each do |attribute|
            if opts[attribute]
              tag_attributes[attribute] = opts[attribute]
            end
          end
          if identifiers[:doi]
            tag_attributes["data-doi"] = identifiers[:doi]
          end
          if identifiers[:pmid]
            tag_attributes["data-pmid"] = identifiers[:pmid]
          end
          if identifiers[:arxiv]
            tag_attributes["data-arxiv-id"] = identifiers[:arxiv]
          end

          content_tag :div, "", tag_attributes
        end
      end

      def self.altmetric_embed_script
        return "<script type='text/javascript' src='https://d1bxh8uas1mnw7.cloudfront.net/assets/embed.js'></script>".html_safe
      end

      private

      # see if there are any identifiers altmetrics can use
      def recognized_identifiers?
        document.recognized_identifiers.any? { |k,v| [:doi, :pmid, :arxiv].include? k }
      end

      def current?
        date = document['pub_date_tsort'].try(:first)
        date.present? && date.try(:to_i) > 2010
      end
    end
  end
end
