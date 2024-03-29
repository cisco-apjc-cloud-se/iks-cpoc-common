ip_pool_policies = [
  {
  name             = "tf-iks-dmz-gw"
  description      = "K8S IP Pool for External Services using SE ACI as gateway and FTDv for Internet"
  starting_address = "100.64.64.19"
  pool_size        = "10"
  netmask          = "255.255.255.240"
  gateway          = "100.64.64.17"
  primary_dns      = "100.64.62.199"
  },
  {
  name             = "tf-iks-dmz-gw2"
  description      = "2nd K8S IP Pool for External Services using SE ACI as gateway and FTDv for Internet"
  starting_address = "100.64.64.35"
  pool_size        = "10"
  netmask          = "255.255.255.240"
  gateway          = "100.64.64.33"
  primary_dns      = "100.64.62.199"
  }
]

sysconfig_policies = [
  {
    # a.k.a Node OS Configuration
    policy_name  = "tf-iks-cpoc-sysconfig"
    description  = "System config settings for Sydney CPOC DMZ"
    # domain_name = ""
    timezone     = "Australia/Sydney"
    ntp_servers  = ["100.64.255.2"]
    dns_servers  = ["100.64.62.199"]
  }
]

k8s_network_policies = [
  {
    policy_name  = "tf-calico-172"
    description  = "Calico CNI with default CIDRs"
    pod_cidr     = "172.31.0.0/16" # Default
    service_cidr = "172.30.0.0/16" # Default
    cni          = "Calico" # Default
  }
]

# Version policy
version_policies = [
  {
    description     = "K8S 1.20 - Required for AppD-IWO Interop"
    policyName      = "tf-iks-1-20-14" #"tf-iks-ob-latest"
    iksVersionName  = "1.20.14-iks.5" # "1.21.10-iks.0"
  },
  {
    description     = "K8S 1.21.13"
    policyName      = "tf-iks-1-21-13" #"tf-iks-ob-latest"
    iksVersionName  = "1.21.13-iks.0"
  }
]

trusted_registry_polices = []

# runtime_policies = []     # Sensitive!

# infra_config_polices = [] # Sensitive!

addon_policies = [
  {
    policyName        = "tf-smm-1-8-2"
    addonName         = "smm"
    description       = "Terraform-built SMM Policy"
    upgradeStrategy   = "UpgradeOnly"
    installStrategy   = "InstallOnly"
    releaseVersion    = "1.8.2-cisco5-helm3" #"1.8.2-cisco2-helm3"
    # overrides         = "yamlencode({\"demoApplication\":{\"enabled\":false}})" ## Quote function
  }
]

instance_type_policies = [
  {
    description = "IKS ESXi VM sized for SMM"
    name        = "tf-iks-10C-64G-60G"
    cpu         = 10
    memory      = 65536
    disk_size   = 60
  },
  {
    description = "IKS ESXi VM sized for SMM"
    name        = "tf-iks-8C-48G-60G"
    cpu         = 8
    memory      = 49152
    disk_size   = 60
  }
]
