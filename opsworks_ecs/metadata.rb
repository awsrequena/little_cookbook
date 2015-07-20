name        "opsworks_ecs"
description "Support for ECS"
maintainer  "AWS OpsWorks"
license     "Apache 2.0"
version     "1.0.0"

supports "amazon_linux"

recipe "opsworks_ecs::setup", "Install Amazon ECS agent."
recipe "opsworks_ecs::shutdown", "Remove Amazon ECS agent and docker."
recipe "opsworks_ecs::cleanup", "Remove Amazon ECS agent and docker."
recipe "opsworks_ecs::deploy", "not implemented"
recipe "opsworks_ecs::undeploy", "not implemented"
recipe "opsworks_ecs::configure", "not implemented"
