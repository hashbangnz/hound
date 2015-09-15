require 'docker_captain/capistrano'
require 'hashbang_backups/capistrano'
# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'hound'
set :repo_url, 'git@github.com:hashbangnz/hound.git'

set :deploy_via, :remote_cache
set :deploy_to, ->() { "/home/#{fetch(:user)}/dockerised_apps/#{fetch(:application)}" }

set :user, 'deploy'
set :scm, :git
set :pty, true

set :linked_files, fetch(:linked_files, []).push('config/database.yml', '.env')

set :ssh_options, { :forward_agent => true }

namespace :deploy do

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end
