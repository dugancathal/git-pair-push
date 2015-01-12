require 'tmpdir'

RSpec.describe 'git-pair-push' do
  let(:output) { "" }
  let(:pair_push_command) { File.expand_path('../../../bin/git-pair-push', __FILE__) }
  it 'boots the server and outputs the URL' do
    inside_git_repo do
      commit_readme
      git_pair_push
      expect(output).to match(/pair-push-ip:8675/)
    end
  end

  def inside_git_repo(&block)
    Dir.mktmpdir do |path|
      Dir.chdir path do
        create_git_repo
        yield path
      end
    end
  end

  def create_git_repo
    `git init`
  end

  def commit_readme
    `echo "Well done. Thanks for reading." > README.md`
    `git add . && git commit -am "Committing readme"`
  end

  def git_pair_push
    load_path = File.expand_path('../../../lib', __FILE__)
    `ruby -I#{load_path} #{pair_push_command}`
  end
end