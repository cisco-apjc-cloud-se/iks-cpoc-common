terraform {
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "mel-ciscolabs-com"
    workspaces {
      name = "iks-cpoc-common"
    }
  }
  required_providers {
    intersight = {
      source = "CiscoDevNet/intersight"
      # version = "1.0.12"
    }
  }
  experiments = [module_variable_optional_attrs]
}

### Providers ###
provider "intersight" {
  # Configuration options
  apikey    = var.intersight_key
  secretkey = var.intersight_secret
  endpoint =  var.intersight_url
}

### Intersight Organization ###
data "intersight_organization_organization" "org" {
  name = var.org_name
}

## Build Common IKS Policies ##

module "iks_version" {
  source = "terraform-cisco-modules/iks/intersight//modules/version"
  for_each = toset(var.version_policies)

  description	    = each.value.description
  iksVersionName	= each.value.iksVersionName
  org_name        = var.org_name
  policyName	    = each.value.policyName
  tags            = var.tags
}

module "iks_addon_policy" {
  source = "terraform-cisco-modules/iks/intersight//modules/addon_policy"
  for_each = var.addon_policies

  addon	    = each.value
  org_name  = var.org_name
  tags      = var.tags
}

module "iks_infra_config" {
  source = "terraform-cisco-modules/iks/intersight//modules/infra_config_policy"
  for_each = toset(var.infra_config_polices)

  org_name	= var.org_name
  tags      = var.tags
  vmConfig  = each.value.vmConfig
}

module "ip_pool" {
  source = "terraform-cisco-modules/iks/intersight//modules/ip_pool"
  for_each = toset(var.ip_pool_policies)

  description	      = each.value.description
  gateway	          = each.value.gateway
  name	            = each.value.name
  netmask	          = each.value.netmask
  org_name	        = var.org_name
  pool_size	        = each.value.pool_size
  primary_dns	      = each.value.primary_dns
  secondary_dns	    = each.value.secondary_dns
  starting_address  = each.value.starting_address
  tags = var.tags
}

module "iks_network_policy" {
  source = "terraform-cisco-modules/iks/intersight//modules/k8s_network"
  for_each = toset(var.k8s_network_policies)

  cni	          = each.value.cni
  description	  = each.value.description
  org_name	    = var.org_name
  pod_cidr	    = each.value.pod_cidr
  policy_name	  = each.value.policy_name
  service_cidr  = each.value.service_cidr
  tags          = var.tags
}

module "iks_system_policy" {
  source = "terraform-cisco-modules/iks/intersight//modules/k8s_sysconfig"
  for_each = toset(var.sysconfig_policies)

  description	= each.value.description
  dns_servers	= each.value.dns_servers
  domain_name	= each.value.domain_name
  ntp_servers	= each.value.ntp_servers
  org_name	  = var.org_name
  policy_name	= each.value.policy_name
  tags        = var.tags
  timezone    = each.value.timezone
}

module "iks_runtime_policy" {
  source = "terraform-cisco-modules/iks/intersight//modules/runtime_policy"
  for_each = toset(var.runtime_policies)

  description	          = each.value.description
  docker_bridge_cidr    = each.value.docker_bridge_cidr
  docker_no_proxy	      = each.value.docker_no_proxy
  name                  = each.value.name
  org_name	            = var.org_name
  proxy_http_hostname	  = each.value.proxy_http_hostname
  proxy_http_password	  = each.value.proxy_http_password
  proxy_http_port	      = each.value.proxy_http_port
  proxy_http_protocol	  = each.value.proxy_http_protocol
  proxy_http_username	  = each.value.proxy_http_username
  proxy_https_hostname  = each.value.proxy_https_hostname
  proxy_https_password	= each.value.proxy_https_password
  proxy_https_port	    = each.value.proxy_https_port
  proxy_https_protocol	= each.value.proxy_https_protocol
  proxy_https_username	= each.value.proxy_https_username
  tags                  = var.tags
}

module "iks_registry_policy" {
  source = "terraform-cisco-modules/iks/intersight//modules/trusted_registry"
  for_each = toset(var.trusted_registry_polices)

  description	        = each.value.description
  org_name	          = var.org_name
  policy_name	        = each.value.policy_name
  root_ca_registries  = each.value.root_ca_registries
  tags                = var.tags
  unsigned_registries = each.value.unsigned_registries
}

module "iks_worker_profile" {
  source = "terraform-cisco-modules/iks/intersight//modules/worker_profile"
  for_each = toset(var.infra_config_polices)

  cpu	        = each.value.cpu
  description = each.value.description
  disk_size	  = each.value.disk_size
  memory	    = each.value.memory
  name	      = each.value.name
  org_name	  = var.org_name
  tags        = var.tags
}
