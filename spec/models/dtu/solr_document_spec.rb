describe Dtu::SolrDocument do
  describe 'affiliations' do
    let(:source_doc) { {} }
    let(:document) { Dtu::SolrDocument.new(source_doc) }
    describe '#authors_with_affiliations' do
      let(:source_doc) {{ 'author_ts' => [
        "Matos, T.",
        "Senkbeil, Silja",
        "Mendonça, A.",
        "Queiroz, J. A.",
        "Kutter, Jörg Peter",
        "Bulow, L."
      ],
      'affiliation_ts' => [
        'Department of Micro- and Nanotechnology, Technical University of Denmark',
        'ChemLabChip, Department of Micro- and Nanotechnology, Technical University of Denmark',
        'Lund University',
        'University of Beira Interior'
      ],
      'affiliation_associations_json' => '{"editor":[],"supervisor":[],"author":[2,0,3,3,0,2]}'
      }}
      subject { document.authors_with_affiliations }
      it { should be_a Hash }
      it 'preserves the correct ordering' do
        expect(subject.keys.first).to eql 'Matos, T.'
        expect(subject.keys.last).to eql 'Bulow, L.'
      end
      it 'adds footnotes for the relevant institution' do
        expect(subject.values.first).to eql 2
      end

      context 'when there is no association json' do
        let(:source_doc) {{ 'author_ts' => [
            "Matos, T.",
            "Senkbeil, Silja",
            "Mendonça, A.",
            "Queiroz, J. A.",
            "Kutter, Jörg Peter",
            "Bulow, L."
        ],
          'affiliation_ts' => [
              'Department of Micro- and Nanotechnology, Technical University of Denmark',
              'ChemLabChip, Department of Micro- and Nanotechnology, Technical University of Denmark',
              'Lund University',
              'University of Beira Interior'
          ]
        }}
        it { should be_a Hash }
        it 'should return authors without affiliations' do
          expect(subject.values.first).to eql nil
        end
      end
    end
    describe 'editors_with_affiliations' do
      let(:source_doc){{
        'affiliation_associations_json' => '{"editor":[null,2],"supervisor":[],"author":[null,null]}',
        'editor_ts' => ["Kimmel, A.", "Oliver, B."]
        }}
      subject { document.editors_with_affiliations }
      it 'preserves the correct ordering' do
        expect(subject.keys.first).to eql 'Kimmel, A.'
        expect(subject.keys.last).to eql 'Oliver, B.'
      end
      it 'returns nil for null values' do
        expect(subject.values.first).to eql nil
      end
      it 'returns numbers when relevant' do
        expect(subject.values.last).to eql 2
      end
    end
  end
end
