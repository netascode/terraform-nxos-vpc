<!-- BEGIN_TF_DOCS -->
[![Tests](https://github.com/netascode/terraform-nxos-scaffolding/actions/workflows/test.yml/badge.svg)](https://github.com/netascode/terraform-nxos-scaffolding/actions/workflows/test.yml)

# Terraform NXOS Scaffolding Module

Description

Model Documentation: [Link](https://developer.cisco.com/docs/cisco-nexus-3000-and-9000-series-nx-api-rest-sdk-user-guide-and-api-reference-release-9-3x/#!configuring-an-ethernet-interface)

## Examples

```hcl
module "nxos_vpc" {
  source  = "netascode/scaffolding/nxos"
  version = ">= 0.0.1"

  switch_1_name             = "SWITCH1"
  switch_2_name             = "SWITCH2"
  vpc_domain_id             = 123
  keepalive_vrf             = "management"
  keepalive_ip_switch_1     = "10.82.143.17"
  keepalive_ip_switch_2     = "10.82.143.18"
  peer_link_port_channel_id = 10
  peer_link_interfaces      = ["eth1/10", "eth1/11"]
  virtual_port_channels = [
    {
      id         = 100
      mode       = "trunk"
      interfaces = ["eth1/20", "eth1/21"]
    },
    {
      id         = 200
      mode       = "access"
      interfaces = ["eth1/23"]
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
| <a name="input_switch_1_name"></a> [switch\_1\_name](#input\_switch\_1\_name) | Switch 1 Name. | `string` | n/a | yes |
| <a name="input_switch_2_name"></a> [switch\_2\_name](#input\_switch\_2\_name) | Switch 2 Name. | `string` | n/a | yes |
| <a name="input_vpc_domain_id"></a> [vpc\_domain\_id](#input\_vpc\_domain\_id) | VPC Domain ID. | `number` | n/a | yes |
| <a name="input_keepalive_ip_switch_1"></a> [keepalive\_ip\_switch\_1](#input\_keepalive\_ip\_switch\_1) | Switch 1 Keeepalive IP. | `string` | n/a | yes |
| <a name="input_keepalive_ip_switch_2"></a> [keepalive\_ip\_switch\_2](#input\_keepalive\_ip\_switch\_2) | Switch 2 Keeepalive IP. | `string` | n/a | yes |
| <a name="input_keepalive_vrf"></a> [keepalive\_vrf](#input\_keepalive\_vrf) | Switch 1 & Switch 2 Keepalive VRF. | `string` | n/a | yes |
| <a name="input_peer_link_interfaces"></a> [peer\_link\_interfaces](#input\_peer\_link\_interfaces) | List of interfaces part of the vPC Peer-Link. | `list(string)` | n/a | yes |
| <a name="input_peer_link_port_channel_id"></a> [peer\_link\_port\_channel\_id](#input\_peer\_link\_port\_channel\_id) | vPC Peer-Link Port-Channel ID. | `number` | n/a | yes |
| <a name="input_virtual_port_channels"></a> [virtual\_port\_channels](#input\_virtual\_port\_channels) | List of vPCs. | <pre>list(object({<br>    id         = number<br>    mode       = string<br>    interfaces = list(string)<br>  }))</pre> | n/a | yes |

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