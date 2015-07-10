ruby_block "Check connectivity to ECS backend" do
  block do
    system("aws ecs --region=#{node["opsworks"]["instance"]["region"]} discover-poll-endpoint --cluster #{node['opsworks_ecs']['ecs_cluster_name']}")
    Chef::Log.fatal "ECS endpoint not reachable, bailing out." unless $? == 0
  end
end

package "docker"
package "ecs-init"

group "docker" do
  action :create
end

service "docker" do
  supports :restart => true, :reload => true, :status => true

  action :start
end

execute "Install the Amazon ECS agent" do
    command "sudo docker run #{node["docker"]["ecs-agent"]["command"]}"
end

ruby_block "Check that the ECS agent is running" do
  block do
     system("curl http://localhost:#{node['docker']['ecs-agent']['port']}/v1/metadata | grep #{node['opsworks_ecs']['ecs_cluster_name']}")
     Chef::Log.fatal "ECS agent could not start, bailing out." unless $? == 0
  end
end

