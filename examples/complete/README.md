<!-- BEGIN_TF_DOCS -->
# NX-OS vPC Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

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
<!-- END_TF_DOCS -->