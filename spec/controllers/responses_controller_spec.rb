describe ResponsesController do
  describe '#create' do
    context 'with no answers' do
      it 'includes the first question' do
        post 'create', response: { questions: [] }
        expect(assigns(:response).next_question.key).to eq 'EL02'
      end
    end

    context 'with answers' do
      it 'includes the next question' do
        post :create, response: { questions: [{ 'key' => 'EL02', 'answer_value' => 1 }] }, format: 'json'
        expect(assigns(:response).next_question.key).to eq 'EL03'
      end
    end

    context 'with wrongly formatted answer' do
      it 'returns 422' do
        post :create, response: { questions: [{ 'key' => 'EL02' }] }, format: 'json'
        expect(assigns(:response)).to be_nil
        expect(response.status).to eq 422
      end
    end
  end
end
