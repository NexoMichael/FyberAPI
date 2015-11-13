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

end