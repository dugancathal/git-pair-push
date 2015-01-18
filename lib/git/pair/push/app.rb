require 'sinatra/base'
module Git
  module Pair
    module Push
      class App < Sinatra::Base
        enable :sessions
        set inline_templates: true, environment: :production, bind: '0.0.0.0'
        get '/' do
          erb :index
        end

        post '/push' do
          session[:output] = `git push #{settings.git_args.join(' ')} 2>&1`
          sha = `git rev-parse HEAD`.chomp
          redirect "/push/#{sha}"
        end

        get '/push/:sha' do
          @sha = params[:sha]
          @output = session[:output]
          erb :pushed
        end
      end
    end
  end
end