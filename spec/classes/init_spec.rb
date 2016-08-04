require 'spec_helper'
describe 'msktutil' do

  context 'with defaults for all parameters' do
    it { should contain_class('msktutil') }
  end
end
