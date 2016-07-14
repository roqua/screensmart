module Events
  describe Event do
    subject do
      class SomeEvent < described_class; end
      Event.create! response_uuid: 'c8d56681-03be-495e-a78d-472c84098e75',
                    type: 'Events::SomeEvent',
                    data: { requester_email: 'some_doctor@email.dev' }
    end

    describe 'validation of attribute:' do
      describe 'response_uuid' do
        context 'not present' do
          before { subject.response_uuid = nil }
          it { is_expected.not_to be_valid }
        end

        context 'not exactly 36 characters' do
          before { subject.response_uuid = 'a' * 35 }
          it { is_expected.not_to be_valid }
        end
      end

      context 'when data is not present' do
        before { subject.data = nil }
        it { is_expected.not_to be_valid }
      end

      context 'when response_uuid and data are present and valid' do
        it { is_expected.to be_valid }
      end
    end
  end
end
