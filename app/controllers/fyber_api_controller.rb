# encoding: utf-8
require 'json'
require_relative '../../lib/fyber_api'
require_relative '../../lib/offer_api_request'

class FyberAPIController < ApplicationController
  get '/' do
    haml :offers_api
  end

  post '/get_offers' do
    content_type :json

    begin
      result = api_object.get_offers(
          {
              uid: params['uid'],
              pub0: params['pub0'],
              page: params['page'],
          })
    rescue RuntimeError # Response is not valid
      result = {}
    end

    offers = []
    if result['code'] == 'OK' and result['count'] > 0
      offers = result['offers'].map { |offer|
        [
            offer['title'],
            offer['payout'],
            offer['thumbnail']['lowres']
        ]
      }
    end
    offers.to_json
  end

  private

  # FyberAPI configuration - should be separated to external config file
  def api_object
    unless $api
      $api = FyberAPI.new(
          'b07a12df7d52e6c118e5d47d3f9e60135b109a1f',
          {
              appid: 157,
              format: 'json',
              device_id: '2b6f0cc904d137be2e1730235f5664094b83',
              locale: 'de',
              ip: '109.235.143.113'
          }
      )
    end
    $api
  end
end