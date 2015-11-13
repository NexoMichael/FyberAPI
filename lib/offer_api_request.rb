require 'digest/sha1'

class OfferApiRequest

  FIELDS = [
      :format, :appid, :uid, :locale, :device_id, :os_version,
      :apple_idfa, :apple_idfa_tracking_enabled,
      :ip, :pub0, :page, :offer_types, :ps_time, :device, :timestamp
  ].sort().freeze

  MANDATORY_FIELDS = [
      :uid, :os_version, :apple_idfa, :apple_idfa_tracking_enabled
  ].freeze

  attr_accessor :params

  def initialize(params = {})
    keys = params.keys
    wrong_fields = keys - OfferApiRequest::FIELDS
    raise ArgumentError.new("Fields [#{wrong_fields.join(', ')}] are not usable") if wrong_fields.any?
    missed_fields = OfferApiRequest::MANDATORY_FIELDS - params.keys
    raise ArgumentError.new("Fields [#{missed_fields.join(', ')}] are missed") if missed_fields.any?
    # TODO: add additional fields validation
    self.params = params
    self.params[:timestamp] = Time.now.to_i unless self.params[:timestamp]
  end

  def request(api_key)
    params = get_params_string_without_hash
    hashkey = calculate_hashkey(params, api_key)
    "#{params}&hashkey=#{hashkey}"
  end

  private

  def get_params_string_without_hash
    FIELDS.map { |field|
      value = self.params[field]
      value ? "#{field}=#{value}" : nil
    }.compact.join('&')
  end

  def calculate_hashkey(params, api_key)
    Digest::SHA1.hexdigest("#{params}&#{api_key}")
  end

end