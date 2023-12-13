<!-- BEGIN_TF_DOCS -->
[![Tests](https://github.com/netascode/terraform-nxos-vpc/actions/workflows/test.yml/badge.svg)](https://github.com/netascode/terraform-nxos-vpc/actions/workflows/test.yml)

# Terraform NX-OS vPC Module

Manages NX-OS vPC

Model Documentation: [Link](https://developer.cisco.com/docs/cisco-nexus-3000-and-9000-series-nx-api-rest-sdk-user-guide-and-api-reference-release-9-3x/#!configuring-virtual-port-channels/configuring-virtual-port-channels)

## Examples

```hcl
module "nxos_vpc" {
  source  = "netascode/vpc/nxos"
  version = ">= 0.0.1"

  switch_1_name                      = "SWITCH1"
  switch_2_name                      = "SWITCH2"
  vpc_domain_id                      = 123
  vpc_auto_recovery                  = true
  vpc_auto_recovery_interval         = 120
  vpc_delay_restore_orphan_port      = 10
  vpc_delay_restore_svi              = 20
  vpc_delay_restore_vpc              = 20
  vpc_fast_convergence               = true
  vpc_graceful_consistency_check     = false
  vpc_l3_peer_router                 = true
  vpc_l3_peer_router_syslog          = true
  vpc_l3_peer_router_syslog_interval = 1800
  vpc_peer_gateway                   = true
  vpc_role_priority_switch_1         = 10
  vpc_role_priority_switch_2         = 20
  vpc_sys_mac_switch_1               = "0A:0A:0A:01:01:01"
  vpc_sys_mac_switch_2               = "0B:0B:0B:02:02:02"
  vpc_system_priority_switch_1       = 100
  vpc_system_priority_switch_2       = 200
  keepalive_vrf                      = "management"
  keepalive_ip_switch_1              = "10.122.187.114"
  keepalive_ip_switch_2              = "10.122.187.115"
  keepalive_flush_timeout            = 5
  keepalive_interval                 = 500
  keepalive_timeout                  = 10
  peer_link_port_channel_id          = 10
  peer_link_port_channel_mode        = "on"
  peer_link_maximum_links            = 32
  peer_link_minimum_links            = 1
  peer_link_interfaces               = ["eth1/1", "eth1/2"]
  virtual_port_channels = [
    {
      id            = 100
      mode          = "trunk"
      layer         = "Layer2"
      trunk_vlans   = "1-20"
      maximum_links = 32
      minimum_links = 1
      mtu           = 1500
      interfaces    = ["eth1/20", "eth1/22"]
    },
    {
      id          = 200
      mode        = "access"
      access_vlan = 10
      layer       = "Layer2"
      interfaces  = ["eth1/21"]
    }
  ]
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_nxos"></a> [nxos](#requirement\_nxos) | >= 0.5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_nxos"></a> [nxos](#provider\_nxos) | >= 0.5.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_switch_1_name"></a> [switch\_1\_name](#input\_switch\_1\_name) | Switch 1 Name. A device name from the provider configuration. | `string` | n/a | yes |
| <a name="input_switch_2_name"></a> [switch\_2\_name](#input\_switch\_2\_name) | Switch 2 Name. A device name from the provider configuration. | `string` | n/a | yes |
| <a name="input_vpc_domain_id"></a> [vpc\_domain\_id](#input\_vpc\_domain\_id) | vPC Domain ID. | `number` | n/a | yes |
| <a name="input_vpc_auto_recovery"></a> [vpc\_auto\_recovery](#input\_vpc\_auto\_recovery) | vPC Auto-Recovery Feature. | `bool` | `false` | no |
| <a name="input_vpc_auto_recovery_interval"></a> [vpc\_auto\_recovery\_interval](#input\_vpc\_auto\_recovery\_interval) | vPC Auto-Recovery Interval. | `number` | `240` | no |
| <a name="input_vpc_delay_restore_orphan_port"></a> [vpc\_delay\_restore\_orphan\_port](#input\_vpc\_delay\_restore\_orphan\_port) | Delay restore for orphan ports. | `number` | `0` | no |
| <a name="input_vpc_delay_restore_svi"></a> [vpc\_delay\_restore\_svi](#input\_vpc\_delay\_restore\_svi) | Delay restore for SVI. | `number` | `10` | no |
| <a name="input_vpc_delay_restore_vpc"></a> [vpc\_delay\_restore\_vpc](#input\_vpc\_delay\_restore\_vpc) | Delay restore for vPC links. | `number` | `30` | no |
| <a name="input_vpc_fast_convergence"></a> [vpc\_fast\_convergence](#input\_vpc\_fast\_convergence) | vPC Fast Convergence. | `bool` | `false` | no |
| <a name="input_vpc_graceful_consistency_check"></a> [vpc\_graceful\_consistency\_check](#input\_vpc\_graceful\_consistency\_check) | Graceful Type-1 Consistency Check. | `bool` | `true` | no |
| <a name="input_vpc_l3_peer_router"></a> [vpc\_l3\_peer\_router](#input\_vpc\_l3\_peer\_router) | vPC L3 Peer Router. | `bool` | `false` | no |
| <a name="input_vpc_l3_peer_router_syslog"></a> [vpc\_l3\_peer\_router\_syslog](#input\_vpc\_l3\_peer\_router\_syslog) | vPC L3 Peer Router Syslog. | `bool` | `false` | no |
| <a name="input_vpc_l3_peer_router_syslog_interval"></a> [vpc\_l3\_peer\_router\_syslog\_interval](#input\_vpc\_l3\_peer\_router\_syslog\_interval) | vPC L3 Peer Router Syslog Interval. | `number` | `3600` | no |
| <a name="input_vpc_peer_gateway"></a> [vpc\_peer\_gateway](#input\_vpc\_peer\_gateway) | VPC Peer Gateway. | `bool` | `false` | no |
| <a name="input_vpc_peer_ip"></a> [vpc\_peer\_ip](#input\_vpc\_peer\_ip) | vPC Peer IP. | `string` | `"0.0.0.0"` | no |
| <a name="input_vpc_peer_switch"></a> [vpc\_peer\_switch](#input\_vpc\_peer\_switch) | vPC pair switches. | `bool` | `false` | no |
| <a name="input_vpc_role_priority_switch_1"></a> [vpc\_role\_priority\_switch\_1](#input\_vpc\_role\_priority\_switch\_1) | vPC role priority Switch 1. | `number` | `32667` | no |
| <a name="input_vpc_role_priority_switch_2"></a> [vpc\_role\_priority\_switch\_2](#input\_vpc\_role\_priority\_switch\_2) | vPC role priority Switch 2. | `number` | `32667` | no |
| <a name="input_vpc_sys_mac_switch_1"></a> [vpc\_sys\_mac\_switch\_1](#input\_vpc\_sys\_mac\_switch\_1) | System mac Switch 1. | `string` | `"00:00:00:00:00:00"` | no |
| <a name="input_vpc_sys_mac_switch_2"></a> [vpc\_sys\_mac\_switch\_2](#input\_vpc\_sys\_mac\_switch\_2) | System mac Switch 2. | `string` | `"00:00:00:00:00:00"` | no |
| <a name="input_vpc_system_priority_switch_1"></a> [vpc\_system\_priority\_switch\_1](#input\_vpc\_system\_priority\_switch\_1) | System Priority Switch 1. | `number` | `32667` | no |
| <a name="input_vpc_system_priority_switch_2"></a> [vpc\_system\_priority\_switch\_2](#input\_vpc\_system\_priority\_switch\_2) | System Priority Switch 2. | `number` | `32667` | no |
| <a name="input_vpc_track"></a> [vpc\_track](#input\_vpc\_track) | Tracking object to suspend vPC if object goes down. | `number` | `0` | no |
| <a name="input_vpc_virtual_ip"></a> [vpc\_virtual\_ip](#input\_vpc\_virtual\_ip) | vPC virtual IP address (vIP). | `string` | `"0.0.0.0"` | no |
| <a name="input_keepalive_ip_switch_1"></a> [keepalive\_ip\_switch\_1](#input\_keepalive\_ip\_switch\_1) | Switch 1 Keeepalive IP. | `string` | n/a | yes |
| <a name="input_keepalive_ip_switch_2"></a> [keepalive\_ip\_switch\_2](#input\_keepalive\_ip\_switch\_2) | Switch 2 Keeepalive IP. | `string` | n/a | yes |
| <a name="input_keepalive_flush_timeout"></a> [keepalive\_flush\_timeout](#input\_keepalive\_flush\_timeout) | Keepalive flush timeout. | `number` | `3` | no |
| <a name="input_keepalive_interval"></a> [keepalive\_interval](#input\_keepalive\_interval) | Keepalive interval. | `number` | `1000` | no |
| <a name="input_keepalive_timeout"></a> [keepalive\_timeout](#input\_keepalive\_timeout) | Keepalive timeout. | `number` | `5` | no |
| <a name="input_keepalive_vrf"></a> [keepalive\_vrf](#input\_keepalive\_vrf) | Switch 1 & Switch 2 Keepalive VRF. | `string` | n/a | yes |
| <a name="input_peer_link_port_channel_mode"></a> [peer\_link\_port\_channel\_mode](#input\_peer\_link\_port\_channel\_mode) | Peer Link Port-Channel mode | `string` | `"active"` | no |
| <a name="input_peer_link_maximum_links"></a> [peer\_link\_maximum\_links](#input\_peer\_link\_maximum\_links) | Peer Link Port-Channel maximum links. | `number` | `32` | no |
| <a name="input_peer_link_minimum_links"></a> [peer\_link\_minimum\_links](#input\_peer\_link\_minimum\_links) | Peer Link Port-Channel minimum links. | `number` | `1` | no |
| <a name="input_peer_link_mtu"></a> [peer\_link\_mtu](#input\_peer\_link\_mtu) | Peer Link MTU. | `number` | `1500` | no |
| <a name="input_peer_link_interfaces"></a> [peer\_link\_interfaces](#input\_peer\_link\_interfaces) | List of interfaces part of the vPC Peer-Link. | `list(string)` | n/a | yes |
| <a name="input_peer_link_port_channel_id"></a> [peer\_link\_port\_channel\_id](#input\_peer\_link\_port\_channel\_id) | vPC Peer-Link Port-Channel ID. | `number` | n/a | yes |
| <a name="input_virtual_port_channels"></a> [virtual\_port\_channels](#input\_virtual\_port\_channels) | List of vPCs. | <pre>list(object({<br>    id            = number<br>    mode          = string<br>    layer         = string<br>    access_vlan   = optional(string)<br>    trunk_vlans   = optional(string)<br>    maximum_links = optional(number)<br>    minimum_links = optional(number)<br>    mtu           = optional(number)<br>    interfaces    = list(string)<br>  }))</pre> | n/a | yes |

## Outputs

No outputs.

## Resources

| Name | Type |
|------|------|
| [nxos_feature_lacp.fmLacp](https://registry.terraform.io/providers/CiscoDevNet/nxos/latest/docs/resources/feature_lacp) | resource |
| [nxos_feature_vpc.mVpc](https://registry.terraform.io/providers/CiscoDevNet/nxos/latest/docs/resources/feature_vpc) | resource |
| [nxos_physical_interface.l1PhysIf_peer_link](https://registry.terraform.io/providers/CiscoDevNet/nxos/latest/docs/resources/physical_interface) | resource |
| [nxos_physical_interface.l1PhysIf_virtual_port_channel](https://registry.terraform.io/providers/CiscoDevNet/nxos/latest/docs/resources/physical_interface) | resource |
| [nxos_port_channel_interface.pcAggrIf_peer_link](https://registry.terraform.io/providers/CiscoDevNet/nxos/latest/docs/resources/port_channel_interface) | resource |
| [nxos_port_channel_interface.pcAggrIf_virtual_port_channel](https://registry.terraform.io/providers/CiscoDevNet/nxos/latest/docs/resources/port_channel_interface) | resource |
| [nxos_port_channel_interface_member.pcRsMbrIfs_peer_link](https://registry.terraform.io/providers/CiscoDevNet/nxos/latest/docs/resources/port_channel_interface_member) | resource |
| [nxos_port_channel_interface_member.pcRsMbrIfs_virtual_port_channel](https://registry.terraform.io/providers/CiscoDevNet/nxos/latest/docs/resources/port_channel_interface_member) | resource |
| [nxos_rest.vpcKeepalive_switch1](https://registry.terraform.io/providers/CiscoDevNet/nxos/latest/docs/resources/rest) | resource |
| [nxos_rest.vpcKeepalive_switch2](https://registry.terraform.io/providers/CiscoDevNet/nxos/latest/docs/resources/rest) | resource |
| [nxos_rest.vpcPeerLink](https://registry.terraform.io/providers/CiscoDevNet/nxos/latest/docs/resources/rest) | resource |
| [nxos_vpc_domain.vpcDom](https://registry.terraform.io/providers/CiscoDevNet/nxos/latest/docs/resources/vpc_domain) | resource |
| [nxos_vpc_instance.vpcInst](https://registry.terraform.io/providers/CiscoDevNet/nxos/latest/docs/resources/vpc_instance) | resource |
| [nxos_vpc_interface.vpcIf](https://registry.terraform.io/providers/CiscoDevNet/nxos/latest/docs/resources/vpc_interface) | resource |
<!-- END_TF_DOCS -->