# config/deploy.rb
# We're using RVM on a server, need this.
$:.unshift(File.expand_path('./lib', ENV['rvm_path']))
require 'rvm/capistrano'
set :rvm_ruby_string, '1.9.3@csf-twi'
set :rvm_type, :user

# Bundler tasks
require 'bundler/capistrano'

set :application, "csf-twi"
set :repository,  "git@github.com:Mehonoshin/csf-twi.git"
set :scm, :git

# do not use sudo
set :use_sudo, false
set(:run_method) { use_sudo ? :sudo : :run }

# This is needed to correctly handle sudo password prompt
default_run_options[:pty] = true

set :user, "csf"
set :group, user
set :runner, user

set :host, "#{user}@production.cspub.net" # We need to be able to SSH to that box as this user.
role :web, host
role :app, host

set :rails_env, :production

# Where will it be located on a server?
set :deploy_to, "/home/csf/#{application}"
set :unicorn_conf, "#{deploy_to}/current/config/unicorn.rb"
set :unicorn_pid, "#{deploy_to}/shared/pids/unicorn.pid"

task :copy_settings_config, roles => :app do
  run "cp #{deploy_to}/shared/twitter.yml #{deploy_to}/current/config/settings/twitter.yml"
end
before "deploy:finalize_update", :copy_settings_config

# Unicorn control tasks
namespace :deploy do
  task :restart do
    run "if [ -f #{unicorn_pid} ] && [ -e /proc/$(cat #{unicorn_pid}) ]; then kill -QUIT `cat #{unicorn_pid}`; else cd #{deploy_to}/current && bundle exec unicorn -Dc #{unicorn_conf} -E #{rails_env}; fi"
  end
  task :start do
    run "cd #{deploy_to}/current && bundle exec unicorn -c #{unicorn_conf} -E #{rails_env} -D"
  end
  task :stop do
    run "[ -f #{unicorn_pid} ] && kill -QUIT `cat #{unicorn_pid}`"
  end
end

