describe ResponsesController, vcr: { cassette_name: 'screensmart', allow_playback_repeats: true,
                                     match_requests_on: [:body, :uri, :method] } do
  describe '#create' do
    context 'with no answers' do
      it 'includes the first question' do
        post 'create'
        expect(assigns(:response).next_question.key).to eq 'EL02'
      end
    end

    context 'with answers' do
      it 'includes the next question' do
        post 'create', answers: { 'EL02' => 1 }
        expect(assigns(:response).next_question.key).to eq 'EL03'
      end
    end

    it 'authorizes'
  end
end
