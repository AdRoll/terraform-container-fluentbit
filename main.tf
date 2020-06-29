data "aws_region" "current" {}

locals {
  # If logging is enabled, then log to cloudwatch, otherwise use the inputted var.log_configuration
  log_configuration = length(var.logging_group_name) > 0 ? {
    logDriver = "awslogs"
    options = {
      awslogs-group         = var.logging_group_name
      awslogs-region        = data.aws_region.current.name
      awslogs-stream-prefix = "ecs"
    }
    secretOptions = null
  } : var.log_configuration

  container_image = coalesce(var.container_image, "906394416424.dkr.ecr.${data.aws_region.current.name}.amazonaws.com/aws-for-fluent-bit:latest")
}

module "container" {
  source = "git::https://github.com/cloudposse/terraform-aws-ecs-container-definition.git?ref=tags/0.37.0"

  container_name               = var.container_name
  container_image              = local.container_image
  essential                    = var.essential
  entrypoint                   = var.entrypoint
  command                      = var.command
  working_directory            = var.working_directory
  readonly_root_filesystem     = var.readonly_root_filesystem
  mount_points                 = var.mount_points
  dns_servers                  = var.dns_servers
  dns_search_domains           = var.dns_search_domains
  ulimits                      = var.ulimits
  repository_credentials       = var.repository_credentials
  links                        = var.links
  volumes_from                 = var.volumes_from
  user                         = var.user
  container_depends_on         = var.container_depends_on
  privileged                   = var.privileged
  port_mappings                = var.port_mappings
  healthcheck                  = var.healthcheck
  firelens_configuration       = var.firelens_configuration
  linux_parameters             = var.linux_parameters
  log_configuration            = local.log_configuration
  container_memory             = var.container_memory
  container_memory_reservation = var.container_memory_reservation
  container_cpu                = var.container_cpu
  map_environment              = var.map_environment
  environment_files            = var.environment_files
  secrets                      = var.secrets
  docker_labels                = var.docker_labels
  start_timeout                = var.start_timeout
  stop_timeout                 = var.stop_timeout
  system_controls              = var.system_controls
  extra_hosts                  = var.extra_hosts
  container_definition         = var.container_definition
}
