service "ecs" do
  action :stop

  ignore_failure true
end

execute "Stop ECS agent" do
  command "docker stop $(docker ps -a | grep amazon-ecs-agent | awk '{print $1}')"

  only_if do
    ::File.exist?("/usr/bin/docker") && OpsWorks::ShellOut.shellout("docker ps -a").include?("amazon-ecs-agent")
  end
end

execute "Remove ECS agent" do
  command "docker rm $(docker ps -a | grep amazon-ecs-agent | awk '{print $1}')"

  only_if do
    ::File.exist?("/usr/bin/docker") && OpsWorks::ShellOut.shellout("docker ps -a").include?("amazon-ecs-agent")
  end
end

execute "Remove ECS agent image" do
  command "docker rmi $(docker images | grep amazon-ecs-agent | awk '{print $3}')"

  only_if do
    node["docker"]["ecs-agent"]["remove_ecs_agent_image"] && ::File.exist?("/usr/bin/docker") && OpsWorks::ShellOut.shellout("docker images").include?("amazon-ecs-agent")
  end
end
