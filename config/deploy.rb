# load "config/recipes/base.rb"
# load "config/recipes/nginx.rb"
# load "config/recipes/unicorn.rb"
# load "config/recipes/postgresql.rb"
# load "config/recipes/nodejs.rb"
# load "config/recipes/rbenv.rb"
#load "config/recipes/check.rb"

# config valid only for Capistrano 3.1
lock '3.1.0'

set :application, 'blog2'
set :deploy_user, "deployer"

# Default value for :scm is :git
set :scm, :git

set :repo_url, 'git@github.com:enter08/blog2.git'

set :rbenv_type, :user # or :system, depends on your rbenv setup
set :rbenv_ruby, '2.1.0'
set :rbenv_bootstrap, "bootstrap-ubuntu-12-04"
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}
set :rbenv_roles, :all # default value


# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

# Default deploy_to directory is /var/www/my_app



# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
set :pty, true
set :ssh_options, { :forward_agent => true }

# Default value for :linked_files is []
set :linked_files, %w{config/database.yml}

# Default value for linked_dirs is []
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

set(:config_files, %w(
	nginx_unicorn
	database.yml
	unicorn.rb 
	unicorn_init
))

# set(:executable_config_files, %w(
# 	unicorn_init
# ))

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5


#after "deploy", "deploy:cleanup"

# namespace :deploy do

#   desc 'Restart application'
#   task :restart do
#     on roles(:app), in: :sequence, wait: 5 do
#       # Your restart mechanism here, for example:
#       # execute :touch, release_path.join('tmp/restart.txt')
#     end
#   end

#   after :publishing, :restart

#   after :restart, :clear_cache do
#     on roles(:web), in: :groups, limit: 3, wait: 10 do
#       # Here we can do anything such as:
#       # within release_path do
#       #   execute :rake, 'cache:clear'
#       # end
#     end
#   end

# end
