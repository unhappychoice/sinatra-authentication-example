require 'sinatra/base'

class Server < Sinatra::Base

  configure do
    enable :sessions
  end

  before do
  end

  helpers do

    def auth? session_token
      session_token ? true : false
    end

    def current_user? user
      user ? true : false
    end

  end

  get '/' do
    @user = session[:user]
    erb :home
  end

  get '/login' do
    erb :login
  end

  get '/logout' do
    session[:user] = nil
    session[:token] = nil
    redirect '/'
  end

  post '/auth' do

    id = params[:id]
    session[:user] = params[:id]
    password = params[:password]

    if password == 'password' && id == 'user'
      session[:token] ||= SecureRandom.urlsafe_base64
      redirect '/'
    end
    p 'Login Failed'

  end

  get '/require_auth' do

    if auth? session[:token]
      @token = session[:token].to_s
      erb :require_auth
    else
      p "login required"
    end

  end

end

Server.run! :host => 'localhost', :port => 3000, :environment => :production
