require_relative '../../config/environment'
require 'pry'
class ApplicationController < Sinatra::Base
  configure do
    set :views, Proc.new { File.join(root, "../views/") }
    enable :sessions unless test?
    set :session_secret, "secret"
  end

  get '/' do
    erb :index
  end

  post '/login' do
    #binding.pry
    @user = User.find_by(user_name: params[:user_name])
    #binding.pry
    if @user != nil
    #  raise session.inspect
      session[:id] = @user.id
      redirect '/account'
    else
      erb :error
    end
  end

  get '/account' do
    if session.key?("id")
      @user = User.find(session[:id])
      erb :account
    else
      erb :error
    end
  end

  get '/logout' do
    session.clear

    redirect '/'
  end


end
