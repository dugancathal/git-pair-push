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

__END__

@@ layout
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Git Pair Push</title>

  <link href="//maxcdn.bootstrapcdn.com/bootstrap/3.3.1/css/bootstrap.min.css" rel="stylesheet">

  <style>
    #the-button {
      position: fixed;
      width: 100%;
      height: 100%;
    }
  </style>
</head>
<body>
  <div class="container-fluid">
    <div class="row">
      <%= yield %>
    </div>
  </div>
</body>
</html>

@@ index
<form action='/push' method='post'>
<button class='btn btn-danger' id="the-button">Ship It</button>
</form>

@@ pushed
<div class='col-md-6 text-center'>
  <h1>Pushed It!</h1>
  <p>You just pushed <%= @sha %></p>
  <p>
    Git wanted me to tell you:
  </p>
  <pre>
    <%= @output %>
  </pre>
</div>