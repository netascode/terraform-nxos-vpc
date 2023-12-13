
locals {
  switches_set = concat([var.switch_1_name], [var.switch_2_name])
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
        id       = "${device_name}_${vpc.id}"
        device   = device_name
        vpc_id   = vpc.id
        vpc_mode = vpc.mode
      }
    ]
  ])

  device_virtual_port_channels_interfaces = flatten([
    for device_name in local.switches_set : [
      for vpc in var.virtual_port_channels : [
        for iface in vpc.interfaces : {
          id            = "${device_name}_${vpc.id}_${iface}"
          device        = device_name
          vpc_id        = vpc.id
          vpc_mode      = vpc.mode
          vpc_interface = iface
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
  for_each    = toset(local.switches_set)
  device      = each.value
  admin_state = "enabled"
  domain_id   = var.vpc_domain_id
  depends_on  = [nxos_vpc_instance.vpcInst]
}

resource "nxos_rest" "vpcKeepalive_switch1" {
  device     = var.switch_1_name
  dn         = "sys/vpc/inst/dom/keepalive"
  class_name = "vpcKeepalive"
  content = {
    destIp = var.keepalive_ip_switch_2
    srcIp  = var.keepalive_ip_switch_1
    vrf    = var.keepalive_vrf
  }
  depends_on = [nxos_vpc_domain.vpcDom]
}

resource "nxos_rest" "vpcKeepalive_switch2" {
  device     = var.switch_2_name
  dn         = "sys/vpc/inst/dom/keepalive"
  class_name = "vpcKeepalive"
  content = {
    destIp = var.keepalive_ip_switch_1
    srcIp  = var.keepalive_ip_switch_2
    vrf    = var.keepalive_vrf
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
  layer        = "Layer2"
}

resource "nxos_port_channel_interface" "pcAggrIf_peer_link" {
  for_each          = toset(local.switches_set)
  device            = each.value
  interface_id      = "po${var.peer_link_port_channel_id}"
  port_channel_mode = "active"
  mode              = "trunk"
  delay             = 1
  maximum_links     = 32
  minimum_links     = 1
  mtu               = 1500
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
  mode         = each.value.vpc_mode
  admin_state  = "up"
  layer        = "Layer2"
}

resource "nxos_port_channel_interface" "pcAggrIf_virtual_port_channel" {
  for_each          = { for item in local.device_virtual_port_channels : item.id => item }
  device            = each.value.device
  interface_id      = "po${each.value.vpc_id}"
  port_channel_mode = "active"
  mode              = each.value.vpc_mode
  delay             = 1
  maximum_links     = 32
  minimum_links     = 1
  mtu               = 1500
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
