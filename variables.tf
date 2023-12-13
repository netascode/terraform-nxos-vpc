variable "switch_1_name" {
  description = "Switch 1 Name."
  type        = string
}

variable "switch_2_name" {
  description = "Switch 2 Name."
  type        = string
}

variable "vpc_domain_id" {
  description = "VPC Domain ID."
  type        = number
}


variable "keepalive_ip_switch_1" {
  description = "Switch 1 Keeepalive IP."
  type        = string
}

variable "keepalive_ip_switch_2" {
  description = "Switch 2 Keeepalive IP."
  type        = string
}


variable "keepalive_vrf" {
  description = "Switch 1 & Switch 2 Keepalive VRF."
  type        = string
}

variable "peer_link_interfaces" {
  description = "List of interfaces part of the vPC Peer-Link."
  type        = list(string)
}

variable "peer_link_port_channel_id" {
  description = "vPC Peer-Link Port-Channel ID."
  type        = number
}

variable "virtual_port_channels" {
  description = "List of vPCs."
  type = list(object({
    id         = number
    mode       = string
    interfaces = list(string)
  }))
}