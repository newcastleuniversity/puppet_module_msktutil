require 'spec_helper'
describe 'msktutil' do
  on_supported_os.each do |os, os_facts|
    context "packages on #{os}" do
      let(:facts) { os_facts }

      context 'install' do
        it { is_expected.to contain_package('msktutil').with_ensure('installed') }
      end

      context 'uninstall' do
        let :params do
          {
            'ensure' => 'absent',
          }
        end

        it { is_expected.to contain_package('msktutil').with_ensure('absent') }
      end
    end
  end
end
