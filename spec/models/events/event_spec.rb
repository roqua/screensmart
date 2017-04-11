module Events
  describe Event do
    subject do
      class SomeEvent < described_class; end
      Event.create! response_uuid: 'c8d56681-03be-495e-a78d-472c84098e75',
                    type: 'Events::SomeEvent',
                    data: { requester_email: 'some_doctor@email.dev' }
    end

    describe 'validation of attributes' do
      context 'when response_uuid and data are present and valid' do
        it { is_expected.to be_valid }
      end
    end

    describe '.event_attributes' do
      subject do
        class EventWithAttributes < Event
          event_attributes :first_untyped_attribute,
                           :second_untyped_attribute,
                           some_typed_attribute: :string
        end

        EventWithAttributes.create! first_untyped_attribute: 1,
                                    second_untyped_attribute: { some: 'value' },
                                    some_typed_attribute: 'some string'
      end

      it 'defines typed and untyped attributes for subclasses' do
        expect(subject.first_untyped_attribute).to eq 1
        expect(subject.second_untyped_attribute).to eq 'some' => 'value'
        expect(subject.some_typed_attribute).to eq 'some string'
      end
    end
  end
end
