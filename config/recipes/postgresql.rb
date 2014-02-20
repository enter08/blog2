set_default(:postgresql_host, "localhost")
set_default(:postgresql_user, "blog4")
set_default(:postgresql_password, "secret")
set_default(:postgresql_database, "blog4_production")

namespace :postgresql do
  desc "Install the latest stable release of PostgreSQL."
  task :install do
    on roles(:db) do
      execute :sudo, "add-apt-repository", "-y", "ppa:pitti/postgresql"
      execute :sudo, "apt-get", "-y", "update"
      execute :sudo, "apt-get", "-y", "install", "postgresql", "libpq-dev"
    end
  end

  after "deploy:install", :install

  desc "Create a database for this application."
  task :create_database do
    on roles(:db) do
      execute :sudo, "-u", "postgres", "psql", "-c", %Q{"create user #{fetch(:postgresql_user)} with password '#{fetch(:postgresql_password)}';"}
      execute :sudo, "-u", "postgres", "psql", "-c", %Q{"create database #{fetch(:postgresql_database)} owner #{fetch(:postgresql_user)};"}
    end
  end
  before "deploy:starting", 'postgresql:create_database'

  desc "Generate the database.yml configuration file."
  task :setup do
    on roles(:app) do
      execute :mkdir, "-p", "#{shared_path}/config"
      template "postgresql.yml.erb", "#{shared_path}/config/database.yml"
    end
  end
  after "deploy:starting", "postgresql:setup"

  # desc "Symlink the database.yml file into latest release"
  # task :symlink do
  #   onroles(:app) do
  #     execute :ln, "-nfs", "#{shared_path}/config/database.yml", "#{release_path}/config/database.yml"
  #   end
  # end
  #after "deploy:finalize_update", "postgresql:symlink"
end