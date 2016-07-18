describe SetAnswer do
  let!(:response_uuid) { SecureRandom.uuid }

  before do
    Events::InvitationSent.create! response_uuid: response_uuid,
                                   requester_email: 'requester@example.dev',
                                   domain_ids: ['POS-PQ']
  end

  let(:params) do
    {
      response_uuid: response_uuid,
      question_id: 'EL02',
      answer_value: 1
    }
  end

  context 'with valid parameters' do
    subject { described_class.run!(params) }

    it 'stores AnswerSet event' do
      expect { subject }.to change { Events::AnswerSet.count }.by 1
    end
  end

  context 'with invalid parameters' do
    subject { described_class.run(params) }

    context 'response_uuid is invalid' do
      it 'has an error when uuid is unkown' do
        params[:response_uuid] = 'FOOBAR'
        expect(subject).to have(1).errors_on(:response_uuid)
      end
    end

    context 'question_id is invalid' do
      it 'has an error on question_id when empty' do
        params[:question_id] = ''
        expect(subject).to have(2).errors_on(:question_id)
      end

      it 'has an error on question_id when key is unknown' do
        params[:question_id] = 'BOGUS'
        expect(subject).to have(1).errors_on(:question_id)
      end
    end

    context 'answer_value is invalid' do
      it 'has an error on answer_value when empty' do
        params[:answer_value] = ''
        expect(subject).to have(1).errors_on(:answer_value)
      end

      it 'has an error on answer_value when value is unknown' do
        params[:answer_value] = 999_999
        expect(subject).to have(1).errors_on(:answer_value)
      end
    end
  end
end
