require 'json'
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

  def get_offers(options = {})
    get_response(create_request_string(options))
  end

  private

  def create_request_string(options = {})
    options = options.merge(@application_config)
    request_string = OfferApiRequest.new(options).request(@api_key)
    "#{OFFERS_URL}?#{request_string}"
  end

  def get_response(request_string)
    response = Net::HTTP.get_response(URI(request_string))
    raise RuntimeError.new('Response is not valid') unless response_valid?(response)
    parse_response(response.body)
  end

  def response_valid?(response)
    Digest::SHA1.hexdigest(response.body + @api_key) == response['X-Sponsorpay-Response-Signature']
  end

  def parse_response(response)
    case @application_config[:format]
    when 'json'
      JSON.parse(response)
    else
      raise ArgumentError.new('Response format is not supported')
    end
  end

end