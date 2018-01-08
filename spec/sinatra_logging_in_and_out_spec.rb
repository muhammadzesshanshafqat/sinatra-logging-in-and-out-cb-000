require 'spec_helper'

describe 'ApplicationController' do
  describe "GET '/'" do
    it "returns a 200 status code" do
      get '/'
      expect(last_response.status).to eq(200)
    end

    it "contains a form for a user to log in" do
      get '/'
      expect(last_response.body).to include("<input")
    end
  end

  describe "POST '/login'" do
    before do
      @user1 = User.create(:user_name => "skittles123", :password => "iluvskittles", :balance => 1000)
      @user2 = User.create(:user_name => "flatiron4lyfe", :password => "Rubie!", :balance => 500)
      @user3 = User.create(:user_name => "kittens1265", :password => "crazycatlady", :balance => 10000)
    end

    it "returns a 302 redirect status code" do
      params = {
        "user_name"=> "skittles123", "password" => "iluvskittles"
      }
      post '/login', params
      expect(last_response.status).to eq(302)
    end

    it "sets session[:user_id] equal to id of the user" do
      post '/login', {
        "user_name"=> "flatiron4lyfe", "password" => "Rubie!"
      }
      follow_redirect!
      expect(session[:id]).to eq(2)
    end

    it "displays the correct username based on session[:user_id]" do
      post '/login', {
        "user_name"=> "kittens1265", "password" => "crazycatlady"
      }
      follow_redirect!
      expect(last_response.body).to include('Welcome kittens1265')
    end

    it "displays the correct balance based on session[:user_id]" do
      post '/login', {
        "user_name"=> "kittens1265", "password" => "crazycatlady"
      }
      follow_redirect!
      expect(last_response.body).to include('10000')
    end

    it "displays a 'Log Out' link" do
      post '/login', {
        "user_name"=> "kittens1265", "password" => "crazycatlady"
      }
      follow_redirect!
      expect(last_response.body).to include('Log Out')
    end


    it "shows the error page if username and ID do not match available users" do
      post '/login', {
        "username"=> "joe", "password" => "nopassword"
      }
      expect(last_response.body).to include('You Must <a href="/">Log In</a> to View Your Balance')
    end
  end

  describe "GET '/account'" do
    it "shows the error page if user goes directly to /account" do
      get '/account'
      expect(last_response.body).to include('You Must <a href="/">Log In</a> to View Your Balance')
    end

    it 'displays the account information if a user is logged in' do
      user1 = User.create(:user_name => "skittles123", :password => "iluvskittles", :balance => 1000)
      params = {
        "user_name"=> "skittles123", "password" => "iluvskittles"
      }
      post '/login', params
      get '/account'
      expect(last_response.body).to include("<h1>Welcome skittles123</h1>")
      expect(last_response.body).to include("<h3>Your Balance: 1000.0</h3>")
    end
  end

  describe "GET '/logout'" do
    it "clears the session" do
      user1 = User.create(:user_name => "skittles123", :password => "iluvskittles", :balance => 1000)
      params = {
        "user_name"=> "skittles123", "password" => "iluvskittles"
      }
      post '/login', params
      get '/logout'
      expect(session[:id]).to be(nil)
    end

    it 'redirects to \'/\'' do
      get '/logout'
      follow_redirect!
      expect(last_request.path_info).to eq('/')
    end

  end

end
