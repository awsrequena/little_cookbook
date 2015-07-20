include_recipe "opsworks_ecs::cleanup"

package "docker"

group "docker" do
  action :create
end

service "docker" do
  action :start
end

package "ecs-init" do
  ignore_failure true
end

directory "/etc/ecs" do
  action :create
  owner "root"
  mode 0755
end

template "ecs.config" do
  path "/etc/ecs/ecs.config"
  source "ecs.config.erb"
  owner "root"
  group "root"
  mode 0644
end

service "ecs" do
  action :start

  ignore_failure true
end

execute "Install the Amazon ECS agent" do
  command "/usr/bin/docker -D run #{node["docker"]["ecs-agent"]["command"]} "

  only_if do
    ::File.exist?("/usr/bin/docker") && !OpsWorks::ShellOut.shellout("docker ps -a").include?("amazon-ecs-agent")
  end
end

ruby_block "Check that the ECS agent is running" do
  block do
    ecs_agent = OpsWorks::ECSAgent.new(node["docker"]["ecs-agent"]["port"])

    Chef::Application.fatal!("ECS agent could not start.") unless ecs_agent.wait_for_availability

    Chef::Application.fatal!("ECS agent is registered to a different cluster.") unless ecs_agent.cluster == node["opsworks_ecs"]["ecs_cluster_name"]
  end
end
