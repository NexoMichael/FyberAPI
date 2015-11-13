require_relative 'offer_api_request'
#
# Implementation of FyberAPI
# Documentation is http://developer.fyber.com/content/current/ios/offer-wall/offer-api/
#
class FyberAPI

  DEFAULTS = {
      appid: 0,
      format: 'json',
      device: '',
      locale: 'de',
      ip: '',
  }

  OFFERS_URL = 'http://api.fyber.com/feed/v1/offers.json'

  def initialize(api_key, options = {})
    raise ArgumentError.new('API Key is not specified') unless api_key
    @api_key = api_key
    @application_config = options.delete_if{ |k| !DEFAULTS.keys.include?(k) }.merge(DEFAULTS)
  end

end