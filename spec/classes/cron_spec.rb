require 'spec_helper'

describe 'msktutil' do
  let(:node) { 'example.ncl.ac.uk' }

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      context 'install cronjobs' do
        case os_facts[:osfamily]
        when 'Debian'
          it {
            is_expected.to contain_file('cronstub').with(
              'ensure'  => 'file',
              'content' => %r{exec /usr/sbin/msktutil --auto-update},
            )
          }
          it {
            is_expected.to contain_file('cronoptions').with(
              'ensure'  => 'file',
              'content' => %r{AUTOUPDATE_OPTIONS="--no-reverse-lookups --computer-name example},
            )
          }
          it { is_expected.to have_file_resource_count(2) }
        else
          it {
            is_expected.to contain_file('cronstub').with(
              'ensure'  => 'file',
              'content' => %r{--computer-name example},
            )
          }
          it { is_expected.not_to contain_file('cronoptions') }
          it { is_expected.to have_file_resource_count(1) }
        end
      end

      context 'install cronjobs with reverse lookup' do
        let :params do
          {
            'usereversedns' => 'yes',
          }
        end

        case os_facts[:osfamily]
        when 'Debian'
          it {
            is_expected.to contain_file('cronstub').with(
              'ensure'  => 'file',
              'content' => %r{exec /usr/sbin/msktutil --auto-update},
            )
          }
          it {
            is_expected.to contain_file('cronoptions').with(
              'ensure'  => 'file',
              'content' => %r{AUTOUPDATE_OPTIONS=" --computer-name example},
            )
          }
          it { is_expected.to have_file_resource_count(2) }
        else
          it {
            is_expected.to contain_file('cronstub').with(
              'ensure'  => 'file',
              'content' => %r{--computer-name example},
            )
          }
          it { is_expected.to have_file_resource_count(1) }
        end
      end

      context 'uninstall cronjobs' do
        let :params do
          {
            'ensure' => 'absent',
          }
        end

        it { is_expected.to contain_file('cronstub').with('ensure' => 'absent') }
        case os_facts[:osfamily]
        when 'Debian'
          it { is_expected.to contain_file('cronoptions').with('ensure' => 'absent') }
        end
      end
    end
  end
end
