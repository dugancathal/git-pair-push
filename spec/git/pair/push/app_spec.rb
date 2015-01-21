require 'git/pair/push/app'
require 'rack/test'

describe Git::Pair::Push::App do
  include Rack::Test::Methods
  def app
    Git::Pair::Push::App.new
  end

  describe 'GET /' do
    it 'returns the index view' do
      get '/'
      expect(last_response).to be_ok
      expect(last_response.body).to match(/Ship It/)
    end
  end

  describe 'GET /push/:sha' do
    it 'shows the sha' do
      get '/push/v-sha'
      expect(last_response.body).to match(/You just pushed v-sha/)
    end

    it 'show the output' do
      get '/push/v-sha', {}, {'rack.session' => {output: 'some git data'}}
      expect(last_response.body).to match(/some git data/)
    end
  end

  describe 'POST /push' do
    let(:client) { double(current_sha: 'new-sha', push: nil) }
    before do
      Git::Pair::Push::App.set :git_args, ['origin', 'master']
      Git::Pair::Push::App.set :git_client, client
    end

    it 'gets the current SHA from git' do
      post '/push'

      expect(client).to have_received(:current_sha)
      follow_redirect!
      expect(last_response.body).to match(/new-sha/)
    end

    it 'pushes the current sha to git' do
      allow(client).to receive(:push).with('origin master')

      post '/push'

      expect(client).to have_received(:push).with('origin master')
    end

    it 'shows the output of the push' do
      allow(client).to receive(:push).and_return('git output. thanks for pushing')

      post '/push'

      follow_redirect!
      expect(last_response.body).to match(/git output. thanks for pushing/)
    end
  end
end