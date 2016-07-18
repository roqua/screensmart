describe AnswersController do
  describe '#create' do
    let(:uuid) { 'c8d56681-03be-495e-a78d-472c84098e75' }
    before do
      Events::InvitationSent.create! response_uuid: uuid,
                                     requester_email: 'some@doctor.dev',
                                     domain_ids: ['POS-PQ']
    end

    subject { post :create, params }

    context 'with valid params' do
      let(:params) do
        {
          response_uuid: uuid,
          question_id: 'EL02',
          answer_value: 1
        }
      end

      it 'creates an AnswerSet event' do
        expect { subject }.to change { Events::AnswerSet.count }.by 1
      end

      it { is_expected.to redirect_to "/responses/#{uuid}" }
    end

    context 'with invalid params' do
    end

    context 'with missing params' do
    end
  end
end
