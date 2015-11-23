describe Dtu::CatalogBehavior do

  controller(ApplicationController) do
    include Blacklight::Catalog
    include Dtu::CatalogBehavior
  end

  describe '#blacklight_config' do
    describe '.document_presenter_class' do
      subject { controller.blacklight_config.document_presenter_class }
      it { is_expected.to eq Dtu::DocumentPresenter }
    end
    describe '.solr_path' do
      subject { controller.blacklight_config.solr_path }
      it { is_expected.to eq 'ddf_publ' }
    end
    describe '.document_solr_path' do
      subject { controller.blacklight_config.document_solr_path }
      it { is_expected.to eq nil }
    end
    describe 'default_solr_params' do
      subject { controller.blacklight_config.default_solr_params }
      it 'includes params for hit highlighting' do
        expect(subject).to include(
                               :hl => true,
                               'hl.snippets' => 3,
                               'hl.usePhraseHighlighter' => true,
                               'hl.fl' => 'title_ts, author_ts, journal_title_ts, conf_title_ts, abstract_ts, publisher_ts',
                               'hl.fragsize' => 300
                           )
      end
    end
    it 'enables highlighting for some fields' do
      pending 'Until we implement highlighting'
      ['author_ts', 'journal_title_ts', 'publisher_ts', 'abstract_ts'].each do |field|
        field_config = controller.blacklight_config.index_fields[field]
        expect(field_config.highlight).to eq true
      end
    end
    describe 'metrics_presenter_classes' do
      subject { controller.blacklight_config.metrics_presenter_classes }
      it {
        pending 'Until we implement metrics defaults'
        is_expected.to eq [Dtu::Metrics::AltmetricPresenter, Dtu::Metrics::IsiPresenter, Dtu::Metrics::DtuOrbitPresenter, Dtu::Metrics::PubmedPresenter]
      }
    end
  end
end