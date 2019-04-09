require 'spec_helper'
describe 'msktutil' do
  on_supported_os.each do |os, os_facts|
    let :facts do
      os_facts
    end

    context "install to #{os}" do
      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_class('msktutil') }
      it { is_expected.to contain_anchor('msktutil::begin') }
      it { is_expected.to contain_anchor('msktutil::end') }
      it { is_expected.to contain_class('msktutil::install') }
      it { is_expected.to contain_class('msktutil::keytab') }
      it { is_expected.to contain_class('msktutil::cron') }
      it { is_expected.to contain_notify('moo') }
    end
    context "uninstall from #{os}" do
      let :params do
        {
          'ensure' => 'absent',
        }
      end

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_class('msktutil') }
      it { is_expected.to contain_anchor('msktutil::begin') }
      it { is_expected.to contain_anchor('msktutil::end') }
      it { is_expected.to contain_class('msktutil::install') }
      it { is_expected.to contain_class('msktutil::keytab') }
      it { is_expected.to contain_class('msktutil::cron') }
    end
  end
end
