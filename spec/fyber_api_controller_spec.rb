ENV['RACK_ENV'] = 'test'

require 'sinatra'
require 'rspec'
require 'rack/test'
require_relative '../app/helpers/application_helper'
require_relative '../app/controllers/application_controller'
require_relative '../app/controllers/fyber_api_controller'

describe FyberAPIController do
  include Rack::Test::Methods

  def app
    FyberAPIController
  end

  describe 'GET /' do
    it 'renders the :index view' do
      get '/'
      expect(last_response).to be_ok
    end
  end
end