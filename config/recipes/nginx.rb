namespace :nginx do
	desc "Install latest stable release of nginx"
	task :install do
		on roles(:web) do
			execute :sudo, "add-apt-repository", "-y", "ppa:nginx/stable"
			execute :sudo, "apt-get", "-y", "update"
			execute :sudo, "apt-get", "-y", "install", "nginx"
		end
	end
	after "deploy:install", :install

	desc "Setup nginx configuration for this application"
	task :setup do
		on roles(:web) do
			template "nginx_unicorn.erb", "/tmp/nginx_conf"
			execute :sudo, "mv", "/tmp/nginx_conf", "/etc/nginx/sites-enabled/#{fetch(:application)}"
			execute :sudo, "rm", "-f", "/etc/nginx/sites-enabled/default"
		end
	end

	after "deploy:finishing", :setup

	%w[start stop restart].each do |command|
		desc "#{command} nginx"
    	task command do
	   	   	on roles(:web) do
	   	    	execute :sudo, "service", "nginx", "#{command}"
	    	end
    	end
	end
	after "nginx:setup", :restart
end