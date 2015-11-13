require_relative '../lib/offer_api_request'

describe OfferApiRequest do

  it 'should be created if all fields are provided' do
    options = {}
    [
        :format, :appid, :uid, :locale, :os_version,
        :timestamp, :apple_idfa, :apple_idfa_tracking_enabled,
        :ip, :pub0, :page, :offer_types, :ps_time, :device
    ].each { |key| options[key] = key }

    OfferApiRequest.new(options)
  end

  it 'should fail if no fields are not provided' do
    options = {}
    [].each { |key| options[key] = key }

    expect { OfferApiRequest.new(options) }.to raise_error(ArgumentError)
  end

  it 'should fail if wrong fields are provided' do
    options = {}
    [:some_field, :some_field2].each { |key| options[key] = key }

    expect { OfferApiRequest.new(options) }.to raise_error(ArgumentError)
  end

end