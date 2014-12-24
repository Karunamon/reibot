#NOTE: This configuration file for Eye assumes you're running as root and with the
#exact same configuration as the author. You will almost certianly need to change
#the PATH and working_dir statements below.

Eye.config do
  logger '/var/log/eye.log'
end

Eye.application 'reibot' do
  env 'RBENV_ROOT' => '~/.rbenv/'
  env 'PATH' => "/root/.rbenv/shims:/root/.rbenv/bin:#{ENV['PATH']}"
  working_dir '/root/reibot-prod/'
  trigger :flapping, times: 3, within: 3.minutes, retry_in: 10.minutes
  process :main do
    env 'RAILS_ENV' => 'production'
    stdall 'reibot.log'
    pid_file 'reibot.pid'
    start_command 'bundle exec ruby main.rb'
    daemonize true
  end
end

