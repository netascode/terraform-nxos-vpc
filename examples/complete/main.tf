module "nxos_vpc" {
  source  = "netascode/vpc/nxos"
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
