module Git
  module Pair
    module Push
      class GitClient
        def current_sha
          `git rev-parse HEAD`.strip
        end

        def push(git_args=nil)
          `git push #{git_args} 2>&1`
        end
      end
    end
  end
end