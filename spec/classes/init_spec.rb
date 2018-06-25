require 'spec_helper'
describe 'msktutil' do
  context 'with defaults for all parameters' do
    it { is_expected.to contain_class('msktutil') }
  end
end
