control 'operating_system' do
  title 'Check OS'
  desc 'Check the Operating System'
  impact 1.0
  describe command('lsb_release -a') do
    its('stdout') { should match (/Ubuntu/) }
  end
end