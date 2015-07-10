default["docker"]["ecs-agent"]["loglevel"] = "info"
default['docker']['ecs-agent']['port'] = 51678
set["docker"]["ecs-agent"]["command"] = ["--name 'ecs-agent'" ,
                                        "--detach=true" ,
                                        "--volume=/var/run/docker.sock:/var/run/docker.sock" ,
                                        "--volume=/var/log/ecs/:/log" ,
                                        "--publish=127.0.0.1:#{node['docker']['ecs-agent']['port']}:#{node['docker']['ecs-agent']['port']}" ,
                                        "--volume=/var/lib/ecs/data:/data" ,
                                        "--env=ECS_LOGFILE=/log/ecs-agent.log" ,
                                        "--env=ECS_LOGLEVEL=#{node["docker"]["ecs-agent"]["loglevel"]}" ,
                                        "--env=ECS_DATADIR=/data" ,
                                        "--env=ECS_CLUSTER=#{node['opsworks_ecs']['ecs_cluster_name']}" ,
                                        "amazon/amazon-ecs-agent:latest"].join(" ")

