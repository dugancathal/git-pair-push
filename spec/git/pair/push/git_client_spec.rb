require 'git/pair/push/git_client'

module Git::Pair::Push
  describe GitClient do
    let(:client) { GitClient.new }
    describe 'current_sha' do
      before do
        allow(client).to receive(:`).and_return 'the-sha  '
      end

      it 'returns the current sha without trailing whitespace' do
        expect(client.current_sha).to eq 'the-sha'
      end

      it 'receives system with argument' do
        expect(client).to receive(:`).with 'git rev-parse HEAD'
        client.current_sha
      end
    end

    describe 'push' do
      it 'calls git push with passed in args' do
        expect(client).to receive(:`).with 'git push origin master 2>&1'
        client.push('origin master')
      end

      it 'defaults to git push' do
        expect(client).to receive(:`).with 'git push  2>&1'
        client.push
      end
    end
  end
end