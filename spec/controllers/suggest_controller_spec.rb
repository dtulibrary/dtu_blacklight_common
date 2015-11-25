describe SuggestController do
  routes { DtuBlacklightCommon::Engine.routes }
  describe 'GET index' do
    it 'returns JSON' do
      get :index, format: 'json'
      expect(response.body).to eq [].to_json
    end
    it 'returns suggestions' do
      get :index, format: 'json', q: '*:new'
      json = JSON.parse(response.body)
      expect(json.count).to be > 0
      expect(json.first['term']).to include 'new'
    end
  end
end