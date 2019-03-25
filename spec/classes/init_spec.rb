require 'spec_helper'
describe 'msktutil' do
  on_supported_os.each do |os, _os_facts|
    context "install to #{os}" do
      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_class('msktutil') }
    end
  end
end
