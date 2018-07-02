describe AppController do
  it 'renders the index page' do
    get :index
    expect(response.status).to eq 200
  end

  it 'renders the privacy policy page' do
    get :privacy
    expect(response.status).to eq 200
  end
end
