describe SetAnswer do
  let!(:response_uuid) { SecureRandom.uuid }

  before do
    Events::InvitationSent.create!(
      response_uuid: response_uuid,
      requester_email: 'behandelaar@example.com',
      domains: ['POS-PQ']
    )
  end

  let(:params) do
    {
      response_uuid: response_uuid,
      question_key: 'EL02',
      answer_value: 1
    }
  end

  context 'with valid parameters' do
    subject { described_class.run!(params) }

    it 'stores AnswerSet event' do
      expect { subject }.to change{
        Events::AnswerSet.count
      }.by(1)
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

    context 'question_key is invalid' do
      it 'has an error on question_key when empty' do
        params[:question_key] = ''
        expect(subject).to have(2).errors_on(:question_key)
      end

      it 'has an error on question_key when key is unknown' do
        params[:question_key] = 'BOGUS'
        expect(subject).to have(1).errors_on(:question_key)
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
