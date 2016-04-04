require 'rails_helper'

describe Dtu::Metrics::OrcidPresenter, type: :view do
  let(:document) { Dtu::SolrDocument.new(
    'format' => format,
    'orcid_ss' => ['0000-0002-8693-9814'],
    'has_orcid_b' => has_orcid
    )}
  let(:presenter) { described_class.new(document, view, {})}
  describe 'should_render?' do
    subject { presenter.should_render? }
    context 'when format is person' do
      let(:format) { 'person' }
      context 'and when has orcid is true' do
        let(:has_orcid) { true }
        it { should be true }
      end
      context 'when has orcid is false' do
        let(:has_orcid) { false }
        it { should be false }
      end
    end
    context 'when format is not person' do
      let(:format) { 'article' }
      let(:has_orcid) { false }
      it { should be false }
    end
  end

  describe 'render' do
    subject { presenter.render }
    let(:has_orcid) { true }
    let(:format) { 'person' }
    it { should be_a String }
  end
end
