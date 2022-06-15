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

locals {
  version_policies_map = {
    for val in var.version_policies :
      val.policyName => val
  }
}

module "iks_version" {
  source = "terraform-cisco-modules/iks/intersight//modules/version"
  for_each = local.version_policies_map # toset(var.version_policies)

  description	    = each.value.description
  iksVersionName	= each.value.iksVersionName
  org_name        = var.org_name
  policyName	    = each.value.policyName
  tags            = var.tags
}

locals {
  addon_policies_map = {
    for val in var.addon_policies :
      val.addonName => val
  }
}

module "iks_addon_policy" {
  source = "terraform-cisco-modules/iks/intersight//modules/addon_policy"
  for_each = local.addon_policies_map #var.addon_policies

  addon	    = each.value
  org_name  = var.org_name
  tags      = var.tags
}

locals {
  ip_pool_policies_map = {
    for val in var.ip_pool_policies :
      val.name => val
  }
}

module "ip_pool" {
  source = "terraform-cisco-modules/iks/intersight//modules/ip_pool"
  for_each = local.ip_pool_policies_map #toset(var.ip_pool_policies)

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

locals {
  k8s_network_policies_map = {
    for val in var.k8s_network_policies :
      val.policy_name => val
  }
}

module "iks_network_policy" {
  source = "terraform-cisco-modules/iks/intersight//modules/k8s_network"
  for_each = local.k8s_network_policies_map #toset(var.k8s_network_policies)

  cni	          = each.value.cni
  description	  = each.value.description
  org_name	    = var.org_name
  pod_cidr	    = each.value.pod_cidr
  policy_name	  = each.value.policy_name
  service_cidr  = each.value.service_cidr
  tags          = var.tags
}

locals {
  sysconfig_policies_map = {
    for val in var.sysconfig_policies :
      val.policy_name => val
  }
}

module "iks_system_policy" {
  source = "terraform-cisco-modules/iks/intersight//modules/k8s_sysconfig"
  for_each = local.sysconfig_policies_map #toset(var.sysconfig_policies)

  description	= each.value.description
  dns_servers	= each.value.dns_servers
  domain_name	= each.value.domain_name
  ntp_servers	= each.value.ntp_servers
  org_name	  = var.org_name
  policy_name = each.value.policy_name
  tags        = var.tags
  timezone    = each.value.timezone
}

locals {
  trusted_registry_polices_map = {
    for val in var.trusted_registry_polices :
      val.policy_name => val
  }
}

module "iks_registry_policy" {
  source = "terraform-cisco-modules/iks/intersight//modules/trusted_registry"
  for_each = local.trusted_registry_polices_map #toset(var.trusted_registry_polices)

  description	        = each.value.description
  org_name	          = var.org_name
  policy_name	        = each.value.policy_name
  root_ca_registries  = each.value.root_ca_registries
  tags                = var.tags
  unsigned_registries = each.value.unsigned_registries
}

locals {
  instance_type_policies_map = {
    for val in var.instance_type_policies :
      val.name => val
  }
}

module "iks_worker_profile" {
  source = "terraform-cisco-modules/iks/intersight//modules/worker_profile"
  for_each = local.instance_type_policies_map #toset(var.instance_type_policies)

  cpu	        = each.value.cpu
  description = each.value.description
  disk_size	  = each.value.disk_size
  memory	    = each.value.memory
  name	      = each.value.name
  org_name	  = var.org_name
  tags        = var.tags
}

### Sensitive Value Policies ####
# NOTE: Can't use sensitive values and "for_each" iterations
# Workaround define each policy directly as separate module

module "iks_infra_config" {
  source = "terraform-cisco-modules/iks/intersight//modules/infra_config_policy"
  org_name	= var.org_name
  tags      = var.tags

  vmConfig = {
    platformType       = "esxi"
    targetName         = "100.64.62.20" # vCenter Target
    policyName         = "tf-iks-aci-dmz"
    description        = "IKS Demo EPG on ACI Internal VRF"
    interfaces         = ["tf-aci-cpoc|dmz|iks-1"]
    vcClusterName      = "CPOC-HX"
    vcDatastoreName    = "CPOC-HX"
    vcResourcePoolName = ""
    vcPassword         = var.vcenter_password
  }
}

module "iks_infra_config2" {
  source = "terraform-cisco-modules/iks/intersight//modules/infra_config_policy"
  org_name	= var.org_name
  tags      = var.tags

  vmConfig = {
    platformType       = "esxi"
    targetName         = "100.64.62.20" # vCenter Target
    policyName         = "tf-iks-aci-dmz2"
    description        = "2nd IKS Demo EPG on ACI Internal VRF"
    interfaces         = ["tf-aci-cpoc|dmz|iks-2"]
    vcClusterName      = "CPOC-HX"
    vcDatastoreName    = "CPOC-HX"
    vcResourcePoolName = ""
    vcPassword         = var.vcenter_password
  }
}

# module "iks_runtime_policy" {
#   source = "terraform-cisco-modules/iks/intersight//modules/runtime_policy"
#
#   description	          = <input>
#   docker_bridge_cidr    = <input>
#   docker_no_proxy	      = <input>
#   name                  = <input>
#   org_name	            = var.org_name
#   proxy_http_hostname	  = <input>
#   proxy_http_password	  = <input>
#   proxy_http_port	      = <input>
#   proxy_http_protocol	  = <input>
#   proxy_http_username	  = <input>
#   proxy_https_hostname  = <input>
#   proxy_https_password	= <input>
#   proxy_https_port	    = <input>
#   proxy_https_protocol	= <input>
#   proxy_https_username	= <input>
#   tags                  = var.tags
# }
