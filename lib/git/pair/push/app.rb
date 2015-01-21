require 'sinatra/base'
require_relative 'git_client'

module Git
  module Pair
    module Push
      class App < Sinatra::Base
        enable :sessions
        set inline_templates: true, environment: :production, bind: '0.0.0.0', git_client: GitClient.new
        get '/' do
          erb :index
        end

        post '/push' do
          sha = settings.git_client.current_sha
          session[:output] = settings.git_client.push(settings.git_args.join(' '))
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