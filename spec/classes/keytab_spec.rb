require 'spec_helper'
describe 'msktutil' do
  on_supported_os.each do |os, os_facts|
    let :facts do
      os_facts
    end

    context "install to #{os}" do
      it { is_expected.to contain_exec('msktutil') }
      it { is_expected.to contain_exec('chmod') }
    end

    context "uninstall from #{os}" do
      let :params do
        {
          'ensure' => 'absent',
        }
      end

      it { is_expected.not_to contain_exec('msktutil') }
      it { is_expected.not_to contain_exec('chmod') }
    end
  end
end
