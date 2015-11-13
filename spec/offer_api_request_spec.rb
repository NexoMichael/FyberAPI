require_relative '../lib/offer_api_request'

describe OfferApiRequest do

  it 'should be created if all fields are provided' do
    options = options_from_list([
                                    :format, :appid, :uid, :locale, :os_version,
                                    :apple_idfa, :apple_idfa_tracking_enabled,
                                    :ip, :pub0, :page, :offer_types, :ps_time, :device])

    OfferApiRequest.new(options)
  end

  it 'should fail if no fields are not provided' do
    options = options_from_list

    expect { OfferApiRequest.new(options) }.to raise_error(ArgumentError)
  end

  it 'should fail if wrong fields are provided' do
    options = options_from_list([:some_field, :some_field2])

    expect { OfferApiRequest.new(options) }.to raise_error(ArgumentError)
  end

  it 'should set <params> if object is created' do
    params = {}
    [:uid, :os_version, :apple_idfa, :apple_idfa_tracking_enabled].each do |k|
      params[k] = Random.rand
    end
    request = OfferApiRequest.new(params)
    expect(request.params.keys - params.keys).equal?(0)

    params.each do |k, v|
      expect(request.params[k]).equal?(v)
    end
  end

  it 'should fill timestamp automatically' do
    options = options_from_list([
                                    :format, :appid, :uid, :locale, :os_version,
                                    :apple_idfa, :apple_idfa_tracking_enabled,
                                    :ip, :pub0, :page, :offer_types, :ps_time, :device])
    t1 = Time.now.to_i
    request = OfferApiRequest.new(options)
    t2 = Time.now.to_i

    timestamp = request.params[:timestamp]
    expect(timestamp).is_a?(Integer)
    expect(timestamp).to be_between(t1, t2)
  end

  private

  def options_from_list(list = [])
    options = {}
    list.each { |key| options[key] = key }
    options
  end

end