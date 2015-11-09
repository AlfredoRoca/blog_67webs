# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'blog_67webs'
set :repo_url, 'git@github.com:AlfredoRoca/blog_67webs.git'
set :deploy_via, :copy #:remote_cache
set :stages, %w(staging) 
set :default_stage, 'staging'

set :tmp_dir, "/home/deployer/tmp"

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default value for :scm is :git
set :scm, :git

# Default value for :format is :pretty
set :format, :pretty

# Default value for :log_level is :debug
set :log_level, :debug

# Default value for :pty is false
set :pty, false
set :ssh_options, { paranoid: false }

# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')

# Default value for linked_dirs is []
# set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 3

