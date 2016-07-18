describe 'Error reporting' do
  unknown_error = 'Onbekende fout. Mail naar support@roqua.nl voor hulp'
  context 'internal server error' do
    def cause_internal_server_error
      visit '/'

      allow_any_instance_of(AnswersController).to receive(:create) do |controller|
        controller.head :internal_server_error
      end

      page.execute_script "$.ajax('/answers', { method: 'POST',
                                                  async: false
                                                })"
    end

    # it 'reports the error to Appsignal' do
    #   pending 'figure out how to assert Appsignal was called'
    # end

    it 'shows the error to the user' do
      expect { cause_internal_server_error }.to raise_error Capybara::Poltergeist::JavascriptError
      expect(page).to have_content unknown_error
    end
  end

  context 'javascript error' do
    it 'shows the error to the user' do
      def cause_javascript_error
        visit '/'
        page.execute_script 'definitely not valid javascript code'
      end

      expect { cause_javascript_error }.to raise_error Capybara::Poltergeist::JavascriptError
      expect(page).to have_content unknown_error
    end
  end
end
