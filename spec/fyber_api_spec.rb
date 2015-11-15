require_relative '../lib/fyber_api'

describe FyberAPI do

  it 'should not initialize without API key' do
    expect { FyberAPI.new(nil) }.to raise_error(ArgumentError)
  end

  it 'should initialize with API key' do
    FyberAPI.new('123')
  end

  it 'only default keys should be present in config' do
    keys = FyberAPI::DEFAULTS.clone
    keys[:some_key] = :some_value
    api = FyberAPI.new('123', keys)
    expect(api.instance_variable_get(:'@application_config')).not_to include(:some_key)
  end

  TEST_REQUEST2 = {
      uid: 'player1',
      ps_time: 1312211903,
      pub0: 'campaign2',
      page: 2,
      timestamp: 1312553361,
      os_version: nil, # It is not normal cause this fields are mandatory
      apple_idfa: nil,
      apple_idfa_tracking_enabled: nil
  }

  CONFIG = {
      appid: 157,
      format: 'json',
      device_id: '2b6f0cc904d137be2e1730235f5664094b831186',
      device: 'tablet',
      ip: '212.45.111.17',
  }

  it 'should create api object for offer request' do
    api = FyberAPI.new('e95a21621a1865bcbae3bee89c4d4f84', CONFIG)
    request_string = api.send(:create_request_string, TEST_REQUEST2)
    expect(request_string).to match('http://api.fyber.com/feed/v1/offers.json?appid=157&device=tablet&format=json&ip=212.45.111.17&locale=de&page=2&ps_time=1312211903&pub0=campaign2&timestamp=1312553361&uid=player1&hashkey=778bc22b29ab049a4d95be18146572573151ad2b')
  end

  it 'should validate response using request header' do
    api = FyberAPI.new('e95a21621a1865bcbae3bee89c4d4f84', CONFIG)
    response = OpenStruct.new(
        {
            body: 'some_body',
            'X-Sponsorpay-Response-Signature' => '79ed5aefb0291b66f7c2d7ddc2977e13f15408f1'
        }
    )
    expect(api.send(:response_valid?, response)).to match(true)
  end

  it 'should validate response using request header and fail in case of error' do
    api = FyberAPI.new('e95a21621a1865bcbae3bee89c4d4f84', CONFIG)
    response = OpenStruct.new(
        {
            body: 'some_body',
            'X-Sponsorpay-Response-Signature' => '123123'
        }
    )
    expect(api.send(:response_valid?, response)).to match(false)
  end

  it 'should validate response using request header and fail in case of not full response' do
    api = FyberAPI.new('e95a21621a1865bcbae3bee89c4d4f84', CONFIG)
    response = OpenStruct.new({ body: 'some_body' })
    expect(api.send(:response_valid?, response)).to match(false)
  end


  # def response_valid?(response)
  #   Digest::SHA1.hexdigest(response.body + @api_key) == response['X-Sponsorpay-Response-Signature']
  # end


  it 'should receive real response' do
    skip 'This is not real test but check of real request'
    config = {
        appid: 157,
        format: 'json',
        device_id: '2b6f0cc904d137be2e1730235f5664094b83',
        locale: 'de',
        ip: '109.235.143.113'
    }
    api_key = 'b07a12df7d52e6c118e5d47d3f9e60135b109a1f'

    api = FyberAPI.new(api_key, config)

    request = {
        offer_types: 112,
        uid: 'player1',
        pub0: 'campaign2',
        page: 2,
        os_version: nil,
        apple_idfa: nil,
        apple_idfa_tracking_enabled: nil
    }
    payload = api.get_offers(request)
    expect(payload['code']).to match('OK')
  end


end