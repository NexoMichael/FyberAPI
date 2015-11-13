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

  TEST_REQUEST = {
      appid: 157,
      uid: 'player1',
      ip: '212.45.111.17',
      locale: 'de',
      device_id: '2b6f0cc904d137be2e1730235f5664094b831186',
      ps_time: 1312211903,
      pub0: 'campaign2',
      page: 2,
      timestamp: 1312553361,
      os_version: nil, # It is not normal cause this fields are mandatory
      apple_idfa: nil,
      apple_idfa_tracking_enabled: nil
  }

  it 'should concatenate all request parameters' do
    request = OfferApiRequest.new(TEST_REQUEST)
    expect(
        request.send(:get_params_string_without_hash)
    ).to match(
             'appid=157&device_id=2b6f0cc904d137be2e1730235f5664094b831186&ip=212.45.111.17&locale=de&page=2&ps_time=1312211903&pub0=campaign2&timestamp=1312553361&uid=player1'
         )
  end

  it 'should generate hashkey' do
    request = OfferApiRequest.new(TEST_REQUEST)
    params = request.send(:get_params_string_without_hash)
    expect(
        request.send(:calculate_hashkey, params, 'e95a21621a1865bcbae3bee89c4d4f84')
    ).to match('7a2b1604c03d46eec1ecd4a686787b75dd693c4d')
  end

  it 'should generate request params' do
    request = OfferApiRequest.new(TEST_REQUEST)
    expect(
        request.request('e95a21621a1865bcbae3bee89c4d4f84')
    ).to match('appid=157&device_id=2b6f0cc904d137be2e1730235f5664094b831186&ip=212.45.111.17&locale=de&page=2&ps_time=1312211903&pub0=campaign2&timestamp=1312553361&uid=player1&hashkey=7a2b1604c03d46eec1ecd4a686787b75dd693c4d')
  end

  private

  def options_from_list(list = [])
    options = {}
    list.each { |key| options[key] = key }
    options
  end

end