include_recipe "opsworks_ecs::cleanup"

ruby_block "Check connectivity to ECS backend" do
  block do
    connectivity = system("aws ecs --region=#{node["opsworks"]["instance"]["region"]} discover-poll-endpoint --cluster #{node['opsworks_ecs']['ecs_cluster_name']}")
    Chef::Log.error "ECS endpoint not reachable, bailing out." unless connectivity
  end
end

case node[:platform]
when "ubuntu"
  file "/etc/apt/sources.list.d/docker.list" do
    content "deb https://get.docker.com/ubuntu docker main"
  end
 execute "Import docker repository key" do
    command "apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys #{node["docker"]["ubuntu"]["fingerprint"]}"
    retries 5
   not_if do
      OpsWorks::ShellOut.shellout("apt-key adv --list-public-keys #{node["docker"]["ubuntu"]["fingerprint"]}") rescue false
    end
  end
  execute "apt-get update"
  package "lxc-docker"
  package "linux-image-extra-#{node["os_version"]}"
  package "linux-image-extra-virtual"

else
  package "docker"
  package "ecs-init"
end

group "docker" do
  action :create
end

service "docker" do
  supports :restart => true, :reload => true, :status => true

  action :start
  notifies :run, "execute[Install the Amazon ECS agent]", :immediately
end

execute "Install the Amazon ECS agent" do
  command "sleep 5 && /usr/bin/docker -D run #{node['docker']['ecs-agent']['command']} "

  only_if do
     ::File.exists?("/usr/bin/docker")
  end

  action :nothing
end

ruby_block "Check that the ECS agent is running" do
  block do
     Chef::Log.error "ECS agent could not start, bailing out." unless `curl -s http://localhost:#{node['docker']['ecs-agent']['port']}/v1/metadata`
  end
end
