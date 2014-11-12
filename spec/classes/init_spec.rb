require 'spec_helper'
describe 'speedtest' do

  context 'with defaults for all parameters' do
    it { should contain_class('speedtest') }
  end
end
