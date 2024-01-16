require 'spec_helper'

describe 'msktutil' do
  let(:node) { 'example.ncl.ac.uk' }

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      context 'install cronjobs' do
        it { is_expected.to compile.with_all_deps }
        case os_facts[:os]['family']
        when 'Debian'
          it {
            is_expected.to contain_file('cronoptions').with(
              'ensure'  => 'file',
              'content' => %r{--no-reverse-lookups --computer-name example},
            )
          }
          it {
            is_expected.to contain_file('cronstub').with(
              'ensure'  => 'file',
              'content' => %r{^/usr/sbin/msktutil --auto-update \$AUTOUPDATE_OPTIONS},
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
        end
      end
      context 'install cronjobs with reverse lookup' do
        let :params do
          {
            'usereversedns' => 'yes',
          }
        end

        it { is_expected.to compile.with_all_deps }
        case os_facts[:os]['family']
        when 'Debian'
          it {
            is_expected.to contain_file('cronoptions').with(
              'ensure'  => 'file',
              'content' => %r{--computer-name example},
            )
          }
          it {
            is_expected.to contain_file('cronstub').with(
              'ensure'  => 'file',
              'content' => %r{^/usr/sbin/msktutil --auto-update \$AUTOUPDATE_OPTIONS},
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

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_file('cronstub').with('ensure' => 'absent') }
        case os_facts[:os]['family']
        when 'Debian'
          it { is_expected.to contain_file('cronoptions').with('ensure' => 'absent') }
        end
      end
    end
  end
end
