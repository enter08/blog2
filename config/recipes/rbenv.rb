set_default :ruby_version, "2.1.0"
set_default :rbenv_bootstrap, "bootstrap-ubuntu-12-04"

set :rbenv_type, :user # or :system, depends on your rbenv setup
set :rbenv_ruby, '2.1.0'
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}
set :rbenv_roles, :all # default value

namespace :rbenv do
  desc "Install rbenv, Ruby, and the Bundler gem"
  task :install do
    on roles(:app) do
      execute :sudo, "apt-get", "-y", "install", "curl", "git-core"
      execute :curl, "-L", "https://raw.github.com/fesplugas/rbenv-installer/master/bin/rbenv-installer", "|", "bash"
      
      f1 = File.expand_path("../templates/rbenv_init", __FILE__)
      
      upload! f1, "/tmp/rbenvrc"
      execute :cat, "/tmp/rbenvrc ~/.bashrc > ~/.bashrc.tmp"
      execute :mv, "~/.bashrc.tmp", "~/.bashrc"
      # execute :sudo, "export", 'PATH="$RBENV_ROOT/bin:$PATH"'
      # execute :sudo, "eval", '"$(rbenv init -)"'
      execute :rbenv, "#{fetch(:rbenv_bootstrap)}"
      execute :rbenv, "install #{fetch(:ruby_version)}"
      execute :rbenv, "global #{fetch(:ruby_version)}"
      execute :gem, "install", "bundler", "--no-ri", "--no-rdoc"
      execute :rbenv, "rehash"
    end
  end
  after "deploy:install", :install
end