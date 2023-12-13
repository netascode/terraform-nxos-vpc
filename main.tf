
locals {
  switches_set = concat([var.switch_1_name], [var.switch_2_name])
  switches_set_info = {
    "${var.switch_1_name}" = {
      name            = var.switch_1_name
      role_priority   = var.vpc_role_priority_switch_1
      sys_mac         = var.vpc_sys_mac_switch_1
      system_priority = var.vpc_system_priority_switch_1
    },
    "${var.switch_2_name}" = {
      name            = var.switch_2_name
      role_priority   = var.vpc_role_priority_switch_2
      sys_mac         = var.vpc_sys_mac_switch_2
      system_priority = var.vpc_system_priority_switch_2
    }
  }
  device_peer_link_interfaces = flatten([
    for device_name in local.switches_set : [
      for iface in var.peer_link_interfaces : {
        id        = "${device_name}_${iface}"
        device    = device_name
        interface = iface
      }
    ]
  ])
  device_virtual_port_channels = flatten([
    for device_name in local.switches_set : [
      for vpc in var.virtual_port_channels : {
        id                = "${device_name}_${vpc.id}"
        device            = device_name
        vpc_id            = vpc.id
        vpc_mode          = vpc.mode
        vpc_layer         = vpc.layer
        vpc_access_vlan   = vpc.access_vlan
        vpc_trunk_vlans   = vpc.trunk_vlans
        vpc_maximum_links = vpc.maximum_links
        vpc_minimum_links = vpc.minimum_links
        vpc_mtu           = vpc.mtu
      }
    ]
  ])

  device_virtual_port_channels_interfaces = flatten([
    for device_name in local.switches_set : [
      for vpc in var.virtual_port_channels : [
        for iface in vpc.interfaces : {
          id              = "${device_name}_${vpc.id}_${iface}"
          device          = device_name
          vpc_id          = vpc.id
          vpc_mode        = vpc.mode
          vpc_access_vlan = vpc.access_vlan
          vpc_trunk_vlans = vpc.trunk_vlans
          vpc_layer       = vpc.layer
          vpc_interface   = iface
        }
      ]
    ]
  ])
}

resource "nxos_feature_vpc" "mVpc" {
  for_each    = toset(local.switches_set)
  device      = each.value
  admin_state = "enabled"
}

resource "nxos_feature_lacp" "fmLacp" {
  for_each    = toset(local.switches_set)
  device      = each.value
  admin_state = "enabled"
}

resource "nxos_vpc_instance" "vpcInst" {
  for_each    = toset(local.switches_set)
  device      = each.value
  admin_state = "enabled"
  depends_on  = [nxos_feature_vpc.mVpc]
}

resource "nxos_vpc_domain" "vpcDom" {
  for_each                       = local.switches_set_info
  device                         = each.key
  admin_state                    = "enabled"
  domain_id                      = var.vpc_domain_id
  auto_recovery                  = var.vpc_auto_recovery == true ? "enabled" : "disabled"
  auto_recovery_interval         = var.vpc_auto_recovery_interval
  delay_restore_orphan_port      = var.vpc_delay_restore_orphan_port
  delay_restore_svi              = var.vpc_delay_restore_svi
  delay_restore_vpc              = var.vpc_delay_restore_vpc
  fast_convergence               = var.vpc_fast_convergence == true ? "enabled" : "disabled"
  graceful_consistency_check     = var.vpc_graceful_consistency_check == true ? "enabled" : "disabled"
  l3_peer_router                 = var.vpc_l3_peer_router == true ? "enabled" : "disabled"
  l3_peer_router_syslog          = var.vpc_l3_peer_router_syslog == true ? "enabled" : "disabled"
  l3_peer_router_syslog_interval = var.vpc_l3_peer_router_syslog_interval
  peer_gateway                   = var.vpc_peer_gateway == true ? "enabled" : "disabled"
  peer_ip                        = var.vpc_peer_ip
  peer_switch                    = var.vpc_peer_switch == true ? "enabled" : "disabled"
  role_priority                  = each.value.role_priority
  sys_mac                        = each.value.sys_mac
  system_priority                = each.value.system_priority
  track                          = var.vpc_track
  virtual_ip                     = var.vpc_virtual_ip
  depends_on                     = [nxos_vpc_instance.vpcInst]
}

resource "nxos_rest" "vpcKeepalive_switch1" {
  device     = var.switch_1_name
  dn         = "sys/vpc/inst/dom/keepalive"
  class_name = "vpcKeepalive"
  content = {
    destIp    = var.keepalive_ip_switch_2
    flushTout = var.keepalive_flush_timeout
    interval  = var.keepalive_interval
    srcIp     = var.keepalive_ip_switch_1
    timeout   = var.keepalive_timeout
    vrf       = var.keepalive_vrf
  }
  depends_on = [nxos_vpc_domain.vpcDom]
}

resource "nxos_rest" "vpcKeepalive_switch2" {
  device     = var.switch_2_name
  dn         = "sys/vpc/inst/dom/keepalive"
  class_name = "vpcKeepalive"
  content = {
    destIp    = var.keepalive_ip_switch_1
    flushTout = var.keepalive_flush_timeout
    interval  = var.keepalive_interval
    srcIp     = var.keepalive_ip_switch_2
    timeout   = var.keepalive_timeout
    vrf       = var.keepalive_vrf
  }
  depends_on = [nxos_vpc_domain.vpcDom]
}

resource "nxos_physical_interface" "l1PhysIf_peer_link" {
  for_each     = { for item in local.device_peer_link_interfaces : item.id => item }
  device       = each.value.device
  interface_id = each.value.interface
  duplex       = "auto"
  speed        = "auto"
  mode         = "trunk"
  admin_state  = "up"
  mtu          = var.peer_link_mtu
  layer        = "Layer2"
}

resource "nxos_port_channel_interface" "pcAggrIf_peer_link" {
  for_each          = toset(local.switches_set)
  device            = each.value
  interface_id      = "po${var.peer_link_port_channel_id}"
  port_channel_mode = var.peer_link_port_channel_mode
  mode              = "trunk"
  delay             = 1
  maximum_links     = var.peer_link_maximum_links
  minimum_links     = var.peer_link_minimum_links
  mtu               = var.peer_link_mtu
  depends_on        = [nxos_feature_lacp.fmLacp]
}

resource "nxos_port_channel_interface_member" "pcRsMbrIfs_peer_link" {
  for_each     = { for item in local.device_peer_link_interfaces : item.id => item }
  device       = each.value.device
  interface_id = "po${var.peer_link_port_channel_id}"
  interface_dn = "sys/intf/phys-[${each.value.interface}]"
  depends_on   = [nxos_port_channel_interface.pcAggrIf_peer_link]
}

resource "nxos_rest" "vpcPeerLink" {
  for_each   = toset(local.switches_set)
  device     = each.value
  dn         = "sys/vpc/inst/dom/keepalive/peerlink"
  class_name = "vpcPeerLink"
  content = {
    id = "po${var.peer_link_port_channel_id}"
  }
  depends_on = [nxos_port_channel_interface_member.pcRsMbrIfs_peer_link, nxos_rest.vpcKeepalive_switch1, nxos_rest.vpcKeepalive_switch2]
}

resource "nxos_physical_interface" "l1PhysIf_virtual_port_channel" {
  for_each     = { for item in local.device_virtual_port_channels_interfaces : item.id => item }
  device       = each.value.device
  interface_id = each.value.vpc_interface
  duplex       = "auto"
  speed        = "auto"
  access_vlan  = each.value.vpc_mode == "access" ? "vlan-${each.value.vpc_access_vlan}" : "vlan-1"
  trunk_vlans  = each.value.vpc_mode == "trunk" ? each.value.vpc_trunk_vlans : "1-4094"
  mode         = each.value.vpc_mode
  admin_state  = "up"
  layer        = each.value.vpc_layer
}

resource "nxos_port_channel_interface" "pcAggrIf_virtual_port_channel" {
  for_each          = { for item in local.device_virtual_port_channels : item.id => item }
  device            = each.value.device
  interface_id      = "po${each.value.vpc_id}"
  port_channel_mode = "active"
  mode              = each.value.vpc_mode
  access_vlan       = each.value.vpc_mode == "access" ? "vlan-${each.value.vpc_access_vlan}" : "vlan-1"
  trunk_vlans       = each.value.vpc_mode == "trunk" ? each.value.vpc_trunk_vlans : "1-4094"
  delay             = 1
  maximum_links     = lookup(each.value, "vpc_maximum_links", 32)
  minimum_links     = lookup(each.value, "vpc_minimum_links", 1)
  mtu               = lookup(each.value, "vpc_mtu", 1500)
  depends_on        = [nxos_feature_lacp.fmLacp]
}

resource "nxos_port_channel_interface_member" "pcRsMbrIfs_virtual_port_channel" {
  for_each     = { for item in local.device_virtual_port_channels_interfaces : item.id => item }
  device       = each.value.device
  interface_id = "po${each.value.vpc_id}"
  interface_dn = "sys/intf/phys-[${each.value.vpc_interface}]"
  depends_on   = [nxos_port_channel_interface.pcAggrIf_virtual_port_channel]
}


resource "nxos_vpc_interface" "vpcIf" {
  for_each                  = { for item in local.device_virtual_port_channels : item.id => item }
  device                    = each.value.device
  vpc_interface_id          = each.value.vpc_id
  port_channel_interface_dn = "sys/intf/aggr-[po${each.value.vpc_id}]"
  depends_on                = [nxos_port_channel_interface_member.pcRsMbrIfs_virtual_port_channel, nxos_rest.vpcPeerLink]
}
