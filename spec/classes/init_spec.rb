require 'spec_helper'
describe 'msktutil' do
  on_supported_os.each do |os, os_facts|
    context "init on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile.with_all_deps }
      context 'install' do
        it { is_expected.to contain_class('msktutil') }
        it { is_expected.to contain_class('msktutil::install') }
        it { is_expected.to contain_class('msktutil::keytab') }
        it { is_expected.to contain_class('msktutil::cron') }
      end
      context 'uninstall' do
        let :params do
          {
            'ensure' => 'absent',
          }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_class('msktutil') }
        it { is_expected.to contain_class('msktutil::install') }
        it { is_expected.to contain_class('msktutil::keytab') }
        it { is_expected.to contain_class('msktutil::cron') }
      end
    end
  end
end
