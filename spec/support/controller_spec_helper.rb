# spec/support/controller_spec_helper.rb
module ControllerSpecHelper
  # # generate tokens from user id
  # def token_generator(user_id)
  #   JsonWebToken.encode(user_id: user_id)
  # end

  # # generate expired tokens from user id
  # def expired_token_generator(user_id)
  #   JsonWebToken.encode({ user_id: user_id }, (Time.now.to_i - 10))
  # end

  # # return valid headers
  # def valid_headers
  #   {
  #     "Authorization" => token_generator(user.id),
  #     "Content-Type" => "application/json"
  #   }
  # end

  # # return invalid headers
  # def invalid_headers
  #   {
  #     "Authorization" => nil,
  #     "Content-Type" => "application/json"
  #   }
  # end

  def signup(email)
    post '/auth', params:  { email: email, password: 'password' }.to_json, headers: { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
  end

  def login(email)
    post '/auth/sign_in', params:  { email: email, password: 'password' }.to_json, headers: { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
  end

  def get_auth_params_from_login_response_headers
    client = response.headers['client']
    token = response.headers['access-token']
    expiry = response.headers['expiry']
    token_type = response.headers['token-type']
    uid = response.headers['uid']

    auth_params = {
      'access-token' => token,
      'client' => client,
      'uid' => uid,
      'expiry' => expiry,
      'token_type' => token_type
    }
    auth_params
  end
end
