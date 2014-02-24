set_default(:unicorn_user, "deployer")
set_default(:unicorn_pid, "/home/deployer/apps/blog2/current/tmp/pids/unicorn.pid")
set_default(:unicorn_config, "/home/deployer/apps/blog2/shared/config/unicorn.rb" )
set_default(:unicorn_log, "/home/deployer/apps/blog2/shared/log/unicorn.log")
set_default(:unicorn_workers, 2)
set_default(:current_path, "/home/deployer/apps/blog2/current")

namespace :unicorn do
  desc "Setup Unicorn initializer and app configuration"
  task :setup do
   on roles(:app) do
      execute :mkdir, "-p", "#{shared_path}/config"
      template "unicorn.rb.erb", fetch(:unicorn_config)
      template "unicorn_init.erb", "/tmp/unicorn_init"
      execute :chmod, "+x", "/tmp/unicorn_init"
      execute :sudo, "mv", "/tmp/unicorn_init", "/etc/init.d/unicorn_#{fetch(:application)}"
      execute :sudo, "update-rc.d", "-f", "unicorn_#{fetch(:application)}", "defaults"
      #erb = File.read(File.expand_path("../templates/unicorn.rb.erb", __FILE__))
      #erb = File.read(File.expand_path("../templates/unicorn_init.erb", __FILE__))
      #puts ERB.new(erb).result(binding)
    end
  end
  after "deploy:finishing", :setup

  %w[start stop restart].each do |command|
      desc "asdas"
      task command do
        on roles(:app) do
         execute "service unicorn_#{fetch(:application)} #{command}"
        end
      end
  end
  #after "deploy:finishing", "unicorn:restart"
end