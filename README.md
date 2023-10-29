

# Solutions

## Solution: load-balancing

Deploys two virtual machines behind a load balancer. Two public IPs are associated with the load balancer. One for incoming traffic. One for outgoing traffic. VMs have outbound connectivity using SNAT.

The VM sku size is a Standard_B2s with 2 CPUs and 4 GB RAM. This is to make sure it can run Azure Disk Encryption which requires a minimum of 4 GB of RAM. 