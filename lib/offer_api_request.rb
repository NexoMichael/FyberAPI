class OfferApiRequest

  FIELDS = [
      :format, :appid, :uid, :locale, :os_version,
      :timestamp, :apple_idfa, :apple_idfa_tracking_enabled,
      :ip, :pub0, :page, :offer_types, :ps_time, :device
  ].sort().freeze

  MANDATORY_FIELDS = [
      :uid, :os_version, :timestamp, :apple_idfa, :apple_idfa_tracking_enabled
  ].freeze

  attr_accessor :params

  def initialize(params = {})
    keys = params.keys
    wrong_fields = keys - OfferApiRequest::FIELDS
    raise ArgumentError.new("Fields #{wrong_fields.join(',')} are not usable") if wrong_fields.any?
    missed_fields = OfferApiRequest::MANDATORY_FIELDS - params.keys
    raise ArgumentError.new("Fields #{missed_fields.join(',')} are missed") if missed_fields.any?
    self.params = params
  end

end