require 'spec_helper'
describe 'msktutil' do
  on_supported_os.each do |os, os_facts|
    let :facts do
      os_facts
    end

    context "install to #{os}" do
      it { is_expected.to contain_file('cronstub').with_ensure('file') }
      case os_facts[:osfamily]
      when 'Debian'
        it { is_expected.to contain_file('cronoptions').with_ensure('file') }
      end
    end

    context "uninstall from #{os}" do
      let :params do
        {
          'ensure' => 'absent',
        }
      end

      it { is_expected.to contain_file('cronstub').with_ensure('absent') }
      case os_facts[:osfamily]
      when 'Debian'
        it { is_expected.to contain_file('cronoptions').with_ensure('absent') }
      end
    end
  end
end
