describe DocumentHelper do

  describe "render_highlighted_abstract" do
    let(:abstract) { "O desenvolvimento marsupial de Cymothoa liannae ocorre em 4 estádios. A distinção entre eles se baseia principalmente na aquisição e perda de cerdas nos apêndices, grau de desenvolvimento dos olhos, comprimento e numero de artículos da antena 2, transformações nas peças bucais (maxilas 1 e 2, palpo mandibular e maxilípede) e ornamentação do datilo dos pereopodes I-III. No ciclo de vida proposto para Cymothoa Liannae é relatada a dinamica das transformações que se processam durante seu desenvolvimento, abordando aspectos sobre fase de infestação e de inversão sexual. Esta espécie, tal como ocorre na maioria dos Cymothoidae é protandro-hermafrodita (cada animal passa por uma fase masculina antes de se tornar fêmea).<br>The marsupial development and the life oyole of Cymothoa liannae are described and discussed. This species is parasite on fishes (Chloroscombrus chrysurus) and. was collected on continental shelf of southeast Brazil from Rio de Janeiro to Rio Grande do Sul. Four distinct marsupial stages are recognize. The stage of infestation and the transition from male to female are also related." }
    let(:truncated_abstract) { truncate(abstract, length: 300, separator:'') }
    let(:document_with_abstract) {SolrDocument.new("type_facet"=>"article", "abstract_ts"=>[abstract])}
    let(:document) { document_with_abstract }
    let(:highlights) { nil }
    let(:short_highlight) { 'The organically produced feed contained sustainable certified fish meal (45%), fish oil (14%), and organic certified wheat'}
    let(:long_highlight) { abstract.gsub('desenvolvimento', '<em>desenvolvimento</em>')}
    let(:rendered) { helper.render_highlighted_abstract(document:document) }
    before do
      allow(document).to receive(:has_highlight_field?).with('abstract_ts').and_return( !highlights.nil? )
      allow(document).to receive(:highlight_field).with('abstract_ts').and_return(highlights)
    end
    describe 'when the first highlight is > 290 characters' do
      let(:highlights) { [long_highlight] }
      it 'throws away the stored value from solr, using the first highlight instead' do
        expect(helper).to receive(:render_snippets).with([long_highlight]).and_return(['rendered snippets'])
        expect(rendered).to eq(['rendered snippets'])
      end
    end
    describe 'when the first highlight is < 290 characters' do
      let(:highlights) { [short_highlight] }
      it 'keeps the stored value from solr, displaying all highlights after it' do
        expect(helper).to receive(:render_snippets).with([truncated_abstract, short_highlight]).and_return(['rendered snippets'])
        expect(rendered).to eq(['rendered snippets'])
      end
    end
    describe 'when there are multiple highlights' do
      let(:highlights) { [long_highlight, short_highlight] }
      it 'renders a snippet for each highlight' do
        expect(helper).to receive(:render_snippets).with([long_highlight,short_highlight]).and_return(['rendered snippets'])
        expect(rendered).to eq(['rendered snippets'])
      end
    end
    describe 'when there are not highlights' do
      let(:highlights) { nil }
      let(:document) { document_with_abstract }
      it "truncates abstract to 300 characters" do
        expect(helper).to receive(:render_snippets).with([truncated_abstract]).and_return(['rendered snippets'])
        expect(rendered).to eq(['rendered snippets'])
      end
    end
    context "when there is no abstract" do
      let(:document) {SolrDocument.new(issn_ss:"aa56T87")}
      it "returns 'No abstract' if there is no abstract" do
        expect(helper).to receive(:render_snippets).with(["No abstract"]).and_return(["No abstract"])
        expect(rendered).to eq ["No abstract"]
      end
    end
  end

  describe 'render_snippets' do
    it 'renders the snippets as div tags' do
      rendered = helper.render_snippets(['one', 'two'])
      expect(rendered.count).to eq 2
      expect(rendered.first).to have_selector('div.snippet', text: 'one...')
      expect(rendered.first).to_not have_selector('.supplemental')
      expect(rendered[1]).to have_selector('div.snippet.supplemental', text: '...two...')
    end
    it 'does not add elipses if they are already there' do
      rendered = helper.render_snippets(['do not duplicate my elipsis...', 'nor my elipsis...', '...nor mine'])
      # you should never see extra elipses
      rendered.each {|tag| expect(tag).to_not have_content('.....') }
    end
  end

  describe 'render_highlight_field' do
    let(:authors) { ["Marie Shelley", "Emily Brontë", "Charlotte Brontë", "George Eliot"] }
    let (:document) { SolrDocument.new('authors_ts' => authors) }
    subject { helper.render_highlight_field(document: document, field: 'authors_ts') }
    before do
      allow(document).to receive(:has_highlight_field?).with('authors_ts').and_return(true)
      allow(document).to receive(:highlight_field).with('authors_ts').and_return(['<em>Emily Brontë</em>'])
    end
    it 'combines the highlighted and non-highlighted authors' do
      expect(subject).to eq(["Marie Shelley", "<em>Emily Brontë</em>", "Charlotte Brontë", 'George Eliot'])
    end
  end

  describe 'render_first_highlight_field' do
    let(:journal_titles) { ['Diabetic Medicine', 'Diab. Med', 'Diab Med']}
    let (:document) { SolrDocument.new('journal_title_ts' => journal_titles) }
    subject { helper.render_first_highlight_field(document: document, field: 'journal_title_ts') }
    before do
      allow(document).to receive(:has_highlight_field?).with('journal_title_ts').and_return(matching_field?)
      allow(document).to receive(:highlight_field).with('journal_title_ts').and_return(['<em>Diabetic</em> <em>Medicine</em>', '<em>Diab</em> <em>Med</em>'])
    end
    context 'when there is a matching highlight field' do
      let(:matching_field?) { true }
      it { is_expected.to eql '<em>Diabetic</em> <em>Medicine</em>' }
    end
    context 'when there is no matching highlight field' do
      let(:matching_field?) { false }
      it { is_expected.to eql 'Diabetic Medicine' }
    end
  end
end
