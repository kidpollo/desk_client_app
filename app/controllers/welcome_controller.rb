class WelcomeController < ApplicationController
  def index
  end

  def auth
    site = params[:site]
    @callback_url = "https://desk-ca-testing.herokuapp.com/welcome/callback"
    @consumer = OAuth::Consumer.new("FuqjmLEe8a90O32CtmRC", "Uhc9reYueNi0g94RxeoXfjETKMghLi5t1uTH1uaM", site: site)
    @request_token = @consumer.get_request_token(oauth_callback: @callback_url)

    session[:token] = @request_token.token
    session[:token_secret] = @request_token.secret
    session[:consumer] = @consumer
    redirect_to @request_token.authorize_url(:oauth_callback => @callback_url)
  end

  def callback
    referer = request.headers["Referer"]
    site = "https://#{URI.parse(referer).host}"

    hash = { oauth_token: session[:token], oauth_token_secret: session[:token_secret]}
    @consumer = session[:consumer]
    @consumer = OAuth::Consumer.new("FuqjmLEe8a90O32CtmRC", "Uhc9reYueNi0g94RxeoXfjETKMghLi5t1uTH1uaM", site: site)
    @request_token  = OAuth::RequestToken.from_hash(@consumer, hash)
    @access_token = @request_token.get_access_token(oauth_verifier: params["oauth_verifier"])
    @cases = @access_token.get('/api/v2/cases?status=pending')
  end
end
