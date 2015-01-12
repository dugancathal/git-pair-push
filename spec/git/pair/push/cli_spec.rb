require 'git/pair/push/cli'
RSpec.describe Git::Pair::Push::Cli do
  describe 'run' do
    context 'with a port arg' do
      it 'parses out the port arg' do
        runner = double('Runner', call: nil)
        Git::Pair::Push::Cli.new(['-p', '32'], runner)
        expect(runner).to have_received(:call).with([], 32)
      end
    end

    context 'with a port flag but no arg' do
      it 'raises an error' do
        runner = double('Runner', call: nil)
        expect { Git::Pair::Push::Cli.new(['-p', 'nope'], runner) }.to raise_error(Git::Pair::Push::Cli::CommandLineArgumentError)
      end
    end

    context 'without a port arg' do
      it 'forwards all the args and uses the default port of 8675' do
        runner = double('Runner', call: nil)
        Git::Pair::Push::Cli.new(['origin', 'master'], runner)
        expect(runner).to have_received(:call).with(['origin', 'master'], 8675)
      end
    end
  end
end