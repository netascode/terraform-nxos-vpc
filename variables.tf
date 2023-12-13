variable "switch_1_name" {
  description = "Switch 1 Name. A device name from the provider configuration."
  type        = string
}

variable "switch_2_name" {
  description = "Switch 2 Name. A device name from the provider configuration."
  type        = string
}

variable "vpc_domain_id" {
  description = "vPC Domain ID."
  type        = number

  validation {
    condition     = var.vpc_domain_id >= 1 && var.vpc_domain_id <= 1000
    error_message = "Allowed values `1`-`1000`."
  }
}

variable "vpc_auto_recovery" {
  description = "vPC Auto-Recovery Feature."
  type        = bool
  default     = false
}

variable "vpc_auto_recovery_interval" {
  description = "vPC Auto-Recovery Interval."
  type        = number
  default     = 240

  validation {
    condition     = var.vpc_auto_recovery_interval >= 60 && var.vpc_auto_recovery_interval <= 3600
    error_message = "Allowed values `60`-`3600`."
  }
}

variable "vpc_delay_restore_orphan_port" {
  description = "Delay restore for orphan ports."
  type        = number
  default     = 0

  validation {
    condition     = var.vpc_delay_restore_orphan_port >= 0 && var.vpc_delay_restore_orphan_port <= 300
    error_message = "Allowed values `0`-`300`."
  }
}

variable "vpc_delay_restore_svi" {
  description = "Delay restore for SVI."
  type        = number
  default     = 10

  validation {
    condition     = var.vpc_delay_restore_svi >= 1 && var.vpc_delay_restore_svi <= 3600
    error_message = "Allowed values `1`-`3600`."
  }
}

variable "vpc_delay_restore_vpc" {
  description = "Delay restore for vPC links."
  type        = number
  default     = 30

  validation {
    condition     = var.vpc_delay_restore_vpc >= 1 && var.vpc_delay_restore_vpc <= 3600
    error_message = "Allowed values `1`-`3600`."
  }
}

variable "vpc_fast_convergence" {
  description = "vPC Fast Convergence."
  type        = bool
  default     = false
}

variable "vpc_graceful_consistency_check" {
  description = "Graceful Type-1 Consistency Check."
  type        = bool
  default     = true
}

variable "vpc_l3_peer_router" {
  description = "vPC L3 Peer Router."
  type        = bool
  default     = false
}

variable "vpc_l3_peer_router_syslog" {
  description = "vPC L3 Peer Router Syslog."
  type        = bool
  default     = false
}

variable "vpc_l3_peer_router_syslog_interval" {
  description = "vPC L3 Peer Router Syslog Interval."
  type        = number
  default     = 3600

  validation {
    condition     = var.vpc_l3_peer_router_syslog_interval >= 1 && var.vpc_l3_peer_router_syslog_interval <= 3600
    error_message = "Allowed values `1`-`3600`."
  }
}

variable "vpc_peer_gateway" {
  description = "VPC Peer Gateway."
  type        = bool
  default     = false
}

variable "vpc_peer_ip" {
  description = "vPC Peer IP."
  type        = string
  default     = "0.0.0.0"

  validation {
    condition     = can(regex("^\\d+\\.\\d+\\.\\d+\\.\\d+$", var.vpc_peer_ip))
    error_message = "Allowed formats are: `1.1.1.1`."
  }
}

variable "vpc_peer_switch" {
  description = "vPC pair switches."
  type        = bool
  default     = false
}

variable "vpc_role_priority_switch_1" {
  description = "vPC role priority Switch 1."
  type        = number
  default     = 32667

  validation {
    condition     = var.vpc_role_priority_switch_1 >= 1 && var.vpc_role_priority_switch_1 <= 65535
    error_message = "Allowed values `1`-`65535`."
  }
}

variable "vpc_role_priority_switch_2" {
  description = "vPC role priority Switch 2."
  type        = number
  default     = 32667

  validation {
    condition     = var.vpc_role_priority_switch_2 >= 1 && var.vpc_role_priority_switch_2 <= 65535
    error_message = "Allowed values `1`-`65535`."
  }
}

variable "vpc_sys_mac_switch_1" {
  description = "System mac Switch 1."
  type        = string
  default     = "00:00:00:00:00:00"

  validation {
    condition     = can(regex("^([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})$", var.vpc_sys_mac_switch_1))
    error_message = "Allowed formats are: `01:02:03:0A:0B:0C`."
  }
}

variable "vpc_sys_mac_switch_2" {
  description = "System mac Switch 2."
  type        = string
  default     = "00:00:00:00:00:00"

  validation {
    condition     = can(regex("^([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})$", var.vpc_sys_mac_switch_2))
    error_message = "Allowed formats are: `01:02:03:0A:0B:0C`."
  }
}

variable "vpc_system_priority_switch_1" {
  description = "System Priority Switch 1."
  type        = number
  default     = 32667

  validation {
    condition     = var.vpc_system_priority_switch_1 >= 1 && var.vpc_system_priority_switch_1 <= 65535
    error_message = "Allowed values `1`-`65535`."
  }
}

variable "vpc_system_priority_switch_2" {
  description = "System Priority Switch 2."
  type        = number
  default     = 32667

  validation {
    condition     = var.vpc_system_priority_switch_2 >= 1 && var.vpc_system_priority_switch_2 <= 65535
    error_message = "Allowed values `1`-`65535`."
  }
}

variable "vpc_track" {
  description = "Tracking object to suspend vPC if object goes down."
  type        = number
  default     = 0

  validation {
    condition     = var.vpc_track >= 0 && var.vpc_track <= 500
    error_message = "Allowed values `0`-`500`."
  }
}

variable "vpc_virtual_ip" {
  description = "vPC virtual IP address (vIP)."
  type        = string
  default     = "0.0.0.0"

  validation {
    condition     = can(regex("^\\d+\\.\\d+\\.\\d+\\.\\d+$", var.vpc_virtual_ip))
    error_message = "Allowed formats are: `1.1.1.1`."
  }
}

variable "keepalive_ip_switch_1" {
  description = "Switch 1 Keeepalive IP."
  type        = string

  validation {
    condition     = can(regex("^\\d+\\.\\d+\\.\\d+\\.\\d+$", var.keepalive_ip_switch_1))
    error_message = "Allowed formats are: `1.1.1.1`."
  }
}

variable "keepalive_ip_switch_2" {
  description = "Switch 2 Keeepalive IP."
  type        = string

  validation {
    condition     = can(regex("^\\d+\\.\\d+\\.\\d+\\.\\d+$", var.keepalive_ip_switch_2))
    error_message = "Allowed formats are: `1.1.1.1`."
  }
}

variable "keepalive_flush_timeout" {
  description = "Keepalive flush timeout."
  type        = number
  default     = 3

  validation {
    condition     = var.keepalive_flush_timeout >= 3 && var.keepalive_flush_timeout <= 10
    error_message = "Allowed values `1`-`10`."
  }
}

variable "keepalive_interval" {
  description = "Keepalive interval."
  type        = number
  default     = 1000

  validation {
    condition     = var.keepalive_interval >= 400 && var.keepalive_interval <= 10000
    error_message = "Allowed values `400`-`10000`."
  }
}

variable "keepalive_timeout" {
  description = "Keepalive timeout."
  type        = number
  default     = 5

  validation {
    condition     = var.keepalive_timeout >= 3 && var.keepalive_timeout <= 20
    error_message = "Allowed values `3`-`20`."
  }
}

variable "keepalive_vrf" {
  description = "Switch 1 & Switch 2 Keepalive VRF."
  type        = string
}

variable "peer_link_port_channel_mode" {
  description = "Peer Link Port-Channel mode"
  type        = string
  default     = "active"

  validation {
    condition     = contains(["on", "static", "active", "passive", "mac-pin"], var.peer_link_port_channel_mode)
    error_message = "Allowed values are: `on`, `static`, `active`, `passive` or `mac-pin`."
  }
}

variable "peer_link_maximum_links" {
  description = "Peer Link Port-Channel maximum links."
  type        = number
  default     = 32

  validation {
    condition     = var.peer_link_maximum_links >= 1 && var.peer_link_maximum_links <= 32
    error_message = "Allowed values `1`-`32`."
  }
}

variable "peer_link_minimum_links" {
  description = "Peer Link Port-Channel minimum links."
  type        = number
  default     = 1

  validation {
    condition     = var.peer_link_minimum_links >= 1 && var.peer_link_minimum_links <= 32
    error_message = "Allowed values `1`-`32`."
  }
}

variable "peer_link_mtu" {
  description = "Peer Link MTU."
  type        = number
  default     = 1500

  validation {
    condition     = var.peer_link_mtu >= 576 && var.peer_link_mtu <= 9216
    error_message = "Allowed values `576`-`9216`."
  }
}

variable "peer_link_interfaces" {
  description = "List of interfaces part of the vPC Peer-Link."
  type        = list(string)

  validation {
    condition = alltrue([
      for iface in var.peer_link_interfaces : can(regex("^eth\\d/\\d+$", iface))
    ])
    error_message = "Allowed format is: `eth1/1`."
  }
}

variable "peer_link_port_channel_id" {
  description = "vPC Peer-Link Port-Channel ID."
  type        = number

  validation {
    condition     = var.peer_link_port_channel_id >= 0 && var.peer_link_port_channel_id <= 65535
    error_message = "Allowed values `0`-`65535`."
  }
}

variable "virtual_port_channels" {
  description = "List of vPCs."
  type = list(object({
    id            = number
    mode          = string
    layer         = string
    access_vlan   = optional(string)
    trunk_vlans   = optional(string)
    maximum_links = optional(number)
    minimum_links = optional(number)
    mtu           = optional(number)
    interfaces    = list(string)
  }))

  validation {
    condition = alltrue([
      for v in var.virtual_port_channels : v.id >= 0 && v.id <= 65535
    ])
    error_message = "`id`: Minimum value: `0`. Maximum value: `65535`."
  }

  validation {
    condition = alltrue([
      for v in var.virtual_port_channels : contains(["access", "trunk"], v.mode)
    ])
    error_message = "`mode`: Allowed values are: `access` or `trunk`."
  }

  validation {
    condition = alltrue([
      for v in var.virtual_port_channels : contains(["Layer2", "Layer3"], v.layer)
    ])
    error_message = "`layer`: Allowed values are: `Layer2` or `Layer3`."
  }

  validation {
    condition = alltrue([
      for v in var.virtual_port_channels : try(v.access_vlan >= 1 && v.access_vlan <= 4094, v.access_vlan == null)
    ])
    error_message = "`access_vlan`: Minimum value: `1`. Maximum value: `4094`."
  }

  validation {
    condition = alltrue([
      for v in var.virtual_port_channels : try(v.maximum_links >= 1 && v.maximum_links <= 32, v.maximum_links == null)
    ])
    error_message = "`maximum_links`: Minimum value: `1`. Maximum value: `32`."
  }

  validation {
    condition = alltrue([
      for v in var.virtual_port_channels : try(v.minimum_links >= 1 && v.minimum_links <= 32, v.minimum_links == null)
    ])
    error_message = "`minimum_links`: Minimum value: `1`. Maximum value: `32`."
  }

  validation {
    condition = alltrue([
      for v in var.virtual_port_channels : try(v.mtu >= 576 && v.minimum_links <= 9216, v.mtu == null)
    ])
    error_message = "`mtu`: Minimum value: `576`. Maximum value: `9216`."
  }

  validation {
    condition = alltrue(flatten([
      for v in var.virtual_port_channels : v.interfaces == null ? [true] : [
        for iface in v.interfaces : can(regex("^eth\\d/\\d+$", iface))
      ]
    ]))
    error_message = "`interfaces`: Allowed format is: `eth1/1`."
  }
}