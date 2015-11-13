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
    @application_config = DEFAULTS.merge(options.delete_if { |k| !DEFAULTS.keys.include?(k) })
  end

  def self.get_offers(options = {})
    request_string = create_request_string(options)
    get_response(request_string)
  end

  private

  def create_request_string(options = {})
    options = options.merge(@application_config)
    OfferApiRequest.new(options).request(@api_key)
  end

  def get_response(request_string)
    request_string = "#{OFFERS_URL}?#{request_string}"
    uri = URI(request_string)
    Net::HTTP.get(uri)
  end

end