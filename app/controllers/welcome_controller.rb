class WelcomeController < ApplicationController
  def index
  end

  def auth
    @callback_url = "http://localhost:5000/welcome/callback"
    @consumer = OAuth::Consumer.new("lGF3bQY755QbAqSkwkXS", "52axpF49nSnGvSdefwKJVqKPHPaLUxRbL0bhSLjs", site: "https://young4.desk.local")
    @request_token = @consumer.get_request_token(oauth_callback: @callback_url)

    session[:token] = @request_token.token
    session[:token_secret] = @request_token.secret
    session[:consumer] = @consumer
    redirect_to @request_token.authorize_url(:oauth_callback => @callback_url)
  end

  def callback
    hash = { oauth_token: session[:token], oauth_token_secret: session[:token_secret]}
    @consumer = session[:consumer]
    @consumer = OAuth::Consumer.new("lGF3bQY755QbAqSkwkXS", "52axpF49nSnGvSdefwKJVqKPHPaLUxRbL0bhSLjs", site: "https://young4.desk.local")
    @request_token  = OAuth::RequestToken.from_hash(@consumer, hash)
    @access_token = @request_token.get_access_token(oauth_verifier: params["oauth_verifier"])
    @photos = @access_token.get('/api/v2/users')
  end
end
