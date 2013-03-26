#require 'rvm/capistrano'
#set :rvm_ruby_string, '1.9.3@habari'
set :user, 'addbent'
set :domain, 'luxlist2.dreamhosters.com'
#pass Cheetah216

require "bundler/capistrano"
# main details
set :application, "testapp"
role :web, domain
role :app, domain
role :db,  domain, :primary => true
set :password, "luxlistAdmin"

# server details
default_run_options[:pty] = true
ssh_options[:forward_agent] = true
set :deploy_to, "/home/#{user}/#{domain}/#{application}"
set :deploy_via, :remote_cache
set :branch, 'master'
set :scm_verbose, true
set :use_sudo, false
set :chmod755, "app config db lib public vendor script script/* public/disp*"

# repo details
set :scm, :git
set :scm_username, "banta"
set :repository, "git@github.com:Banta/testapp.git"
#set :git_enable_submodules, 1
#set :normalize_asset_timestamps, false

# Passenger
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

#Other tasks
namespace :other do
  desc "bundle the app"
  task :bundle do
    run "cd #{current_path}; bundle install"
  end

  desc "precompile assets"
  task :assets do
    run "cd #{current_path}; rake assets:precompile"
  end
end

after "deploy:update", "other:bundle"