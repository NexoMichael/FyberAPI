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


end