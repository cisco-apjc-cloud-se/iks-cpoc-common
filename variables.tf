### Intersight - Common Variables

variable "intersight_key" {
  type = string
}

variable "intersight_secret" {
  type = string
}

variable "intersight_url" {
  type = string
  default = "https://intersight.com"
}

variable "org_name" {
  type = string
  default = "default"
}

variable "tags" {
  type        = list(map(string))
  default     = []
  description = "Tags to be associated with this object in Intersight."
}

### Intersight Kubernetes Policies as List of Objects ###

variable "version_policies" {
  type = list(object({
    # useExisting    = bool
    policyName     = string
    iksVersionName = optional(string)
    description    = optional(string)
    versionName    = optional(string)
  }))
}

# variable "infra_config_polices" {
#   type = list(object({
#     # use_existing       = bool
#     vmConfig = object({
#       platformType       = optional(string)
#       targetName         = optional(string)
#       policyName         = string
#       description        = optional(string)
#       interfaces         = optional(list(string))
#       diskMode           = optional(string)
#       vcTargetName       = optional(string)
#       vcClusterName      = optional(string)
#       vcDatastoreName    = optional(string)
#       vcResourcePoolName = optional(string)
#       vcPassword         = optional(string)
#       })
#   }))
#   sensitive = true
# }

variable "instance_type_policies" {
  type = list(object({
    # use_existing = bool
    description  = optional(string)
    name         = string
    cpu          = optional(number)
    memory       = optional(number)
    disk_size    = optional(number)
  }))
}

# variable "runtime_policies" {
#   type = list(object({
#     # use_existing         = bool
#     create_new           = bool
#     name                 = optional(string)
#     http_proxy_hostname  = optional(string)
#     http_proxy_port      = optional(number)
#     http_proxy_protocol  = optional(string)
#     http_proxy_username  = optional(string)
#     http_proxy_password  = optional(string)
#     https_proxy_hostname = optional(string)
#     https_proxy_port     = optional(number)
#     https_proxy_protocol = optional(string)
#     https_proxy_username = optional(string)
#     https_proxy_password = optional(string)
#     docker_no_proxy      = optional(list(string))
#   }))
#   sensitive = true
# }

variable "addon_policies" {
  type = list(object({
    # createNew        = bool
    policyName       = optional(string)
    addonName        = optional(string)
    description      = optional(string)
    upgradeStrategy  = optional(string)
    installStrategy  = optional(string)
    overrideSets     = optional(list(map(string)))
    overrides        = optional(string)
    releaseName      = optional(string)
    releaseNamespace = optional(string)
    releaseVersion   = optional(string)
  }))
  default = []
}

variable "ip_pool_policies" {
  type = list(object({
    # use_existing        = bool
    name             = string
    description      = optional(string)
    starting_address = optional(string)
    pool_size        = optional(string)
    netmask          = optional(string)
    gateway          = optional(string)
    primary_dns      = optional(string)
    secondary_dns    = optional(string)
  }))
}

variable "k8s_network_policies" {
  type = list(object({
    # use_existing = bool
    policy_name  = string
    description  = optional(string)
    pod_cidr     = optional(string)
    service_cidr = optional(string)
    cni          = optional(string)
  }))
}

variable "trusted_registry_polices" {
  type = list(object({
    # use_existing        = bool
    create_new          = bool
    name                = optional(string)
    root_ca_registries  = optional(list(string))
    unsigned_registries = optional(list(string))
  }))
}

variable "sysconfig_policies" {
  type = list(object({
    # use_existing = bool
    policy_name  = string
    description  = optional(string)
    ntp_servers  = optional(list(string))
    dns_servers  = optional(list(string))
    timezone     = optional(string)
    domain_name  = optional(string)
  }))
}
