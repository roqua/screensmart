describe DomainsController do
  describe '#index' do
    it 'returns the domains returned by the R package' do
      get :index, format: :json

      expect(assigns(:domains)).to include('id' => 'POS-PQ',
                                           'description' => 'Positieve symptomen van psychose',
                                           'norm_population' => 'Algemene bevolking')
    end
  end
end
