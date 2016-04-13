module Dtu
  module Metrics
    class OrcidPresenter < Dtu::Presenter
      presents :document

      def should_render?
        document.person? && document.has_orcid?
      end

      def render
        content_tag :div, class: 'orcid-metric' do
          link_to "http://www.orcid.org/#{document.orcid}", target: '_blank' do
            image_tag('dtu_blacklight_common/orcid_logo.png') + ' ORCID.org'
          end
        end
      end
    end
  end
end
