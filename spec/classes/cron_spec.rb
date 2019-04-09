require 'spec_helper'
describe 'msktutil' do
  let(:node) { 'example.ncl.ac.uk' }

  on_supported_os.each do |os, facts|
    let :facts do
      facts
    end

    context "install cronjobs to #{os}" do
      case facts[:osfamily]
      when 'Debian'
        it {
          is_expected.to contain_file('cronstub').with(
            'ensure'  => 'file',
            'content' => %r{[ "$AUTOUPDATE_ENABLED" = "true" ] || exit 0},
          )
        }
        it {
          is_expected.to contain_file('cronoptions').with(
            'ensure'  => 'file',
            'content' => %r{--no-reverse-lookups --computer-name example --hostname example.ncl.ac.uk --service host/example --service host/example.ncl.ac.uk},
          )
        }
        it { is_expected.to have_file_resource_count(2) }
        it { is_expected.to contain_notify('cronoptions') }
        it { is_expected.to contain_notify('cronstub') }
      else
        it {
          is_expected.to contain_file('cronstub').with(
            'ensure'  => 'file',
            'content' => %r{--auto-update-interval 60},
          )
        }
        it { is_expected.not_to contain_file('cronoptions') }
        it { is_expected.to have_file_resource_count(1) }
      end
    end

    context "install cronjobs to #{os} with reverse lookup" do
      let :params do
        {
          'usereversedns' => 'yes',
        }
      end

      case facts[:osfamily]
      when 'Debian'
        it {
          is_expected.to contain_file('cronstub').with(
            'ensure'  => 'file',
            'content' => %r{[ "$AUTOUPDATE_ENABLED" = "true" ] || exit 0},
          )
        }
        it {
          is_expected.to contain_file('cronoptions').with(
            'ensure'  => 'file',
            'content' => %r{AUTOUPDATE_OPTIONS=" --computer-name},
          )
        }
        it { is_expected.to have_file_resource_count(2) }
      else
        it {
          is_expected.to contain_file('cronstub').with(
            'ensure'  => 'file',
            'content' => %r{--auto-update-interval 60},
          )
        }
        it { is_expected.to have_file_resource_count(1) }
      end
    end

    context "uninstall cronjobs from #{os}" do
      let :params do
        {
          'ensure' => 'absent',
        }
      end

      it { is_expected.to contain_file('cronstub').with('ensure' => 'absent') }
      case facts[:osfamily]
      when 'Debian'
        it { is_expected.to contain_file('cronoptions').with('ensure' => 'absent') }
      end
    end
  end
end
