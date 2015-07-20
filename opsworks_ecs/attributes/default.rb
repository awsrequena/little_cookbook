default["docker"]["ecs-agent"]["port"] = 51678
default["docker"]["ecs-agent"]["remove_ecs_agent_image"] = false
default["docker"]["ecs-agent"]["logfile"] = "/log/ecs-agent.log"
default["docker"]["ecs-agent"]["loglevel"] = "info"
default["docker"]["ecs-agent"]["datadir"] = "/data"
default["docker"]["ecs-agent"]["command"] = ["--name 'ecs-agent'",
                                             "--detach=true",
                                             "--volume=/var/run/docker.sock:/var/run/docker.sock",
                                             "--volume=/var/log/ecs/:/log",
                                             "--publish=127.0.0.1:#{node["docker"]["ecs-agent"]["port"]}:#{node["docker"]["ecs-agent"]["port"]}",
                                             "--volume=/var/lib/ecs/data:#{node["docker"]["ecs-agent"]["datadir"]}",
                                             "--env=ECS_LOGFILE=#{node["docker"]["ecs-agent"]["logfile"]}",
                                             "--env=ECS_LOGLEVEL=#{node["docker"]["ecs-agent"]["loglevel"]}",
                                             "--env=ECS_DATADIR=#{node["docker"]["ecs-agent"]["datadir"]}",
                                             "--env=ECS_CLUSTER=#{node["opsworks_ecs"]["ecs_cluster_name"]}",
                                             "amazon/amazon-ecs-agent:latest"].join(" ")
