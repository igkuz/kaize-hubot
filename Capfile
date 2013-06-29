require 'bundler/capistrano'

set :application, "kaize-hubot"
set :repository, "git://github.com:igkuz/kaize-hubot.git"
server '192.168.30.14', :app, :web, :db, :primary => true

set :branch, "master"
set :deploy_to, "/srv/hubot/"

set :user, "vagrant"
set :scm, :git
set :deploy_via, :remote_cache

namespace :deploy do
  task :install_modules do
    run ""
  end
  task :restart do
    run "sudo /usr/bin/sv /etc/environmet/hubot
  end
end
