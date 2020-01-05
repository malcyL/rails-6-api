# app/controllers/application_controller.rb
class ApplicationController < ActionController::API
        include DeviseTokenAuth::Concerns::SetUserByToken
  include Response
  include ExceptionHandler
  include DeviseTokenAuth::Concerns::SetUserByToken

  # TODO: Really?
  # https://dev.to/risafj/guide-to-devisetokenauth-simple-authentication-in-rails-api-pfj
  # protect_from_forgery unless: -> { request.format.json? }
end
