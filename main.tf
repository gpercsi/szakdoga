
terraform {
  required_version = ">= 0.14.0"
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~>1.47.0"
    }
  }
}


# Kiszolgáló konfig
provider "openstack" {
	#cloud = "sztaki"
	application_credential_id = "ff3588c9e34540f1a0cba0b631a732aa"
	application_credential_secret = "zenfi2-Dowpur-qipzer"
    region = "RegionOne"
	auth_url = "https://sztaki.science-cloud.hu:5000"

}


#FIREWALL - MASTER

resource "openstack_networking_secgroup_v2" "terraform_emqx_master" {
  name        = "terraform_emqx_master"
  description = "Created by Terraform. Do not use or manage manually." 
}

#resource "openstack_networking_secgroup_rule_v2" "secgroup_rule_0"{
#  ethertype = "IPv4"
#  direction = "ingress"
#  port_range_min = -1
#  port_range_max  = -1
#  protocol = "icmp"
#  remote_ip_prefix = "0.0.0.0/0"
#  security_group_id = openstack_networking_secgroup_v2.terraform_emqx_master.id
#}

resource "openstack_networking_secgroup_rule_v2" "secgroup_rule_1" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.terraform_emqx_master.id
}

resource "openstack_networking_secgroup_rule_v2" "secgroup_rule_2" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 1883
  port_range_max    = 1883
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.terraform_emqx_master.id
}

resource "openstack_networking_secgroup_rule_v2" "secgroup_rule_3" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 4369
  port_range_max    = 4380
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.terraform_emqx_master.id
}
resource "openstack_networking_secgroup_rule_v2" "secgroup_rule_4" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 5370
  port_range_max    = 5380
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.terraform_emqx_master.id
}
resource "openstack_networking_secgroup_rule_v2" "secgroup_rule_5" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 8081
  port_range_max    = 8084
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.terraform_emqx_master.id
}
resource "openstack_networking_secgroup_rule_v2" "secgroup_rule_6" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 8883
  port_range_max    = 8883
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.terraform_emqx_master.id
}
resource "openstack_networking_secgroup_rule_v2" "secgroup_rule_7" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 18083
  port_range_max    = 18083
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.terraform_emqx_master.id
}




#Hálózat létrehozása
#resource "openstack_networking_network_v2" "emqx_network" {
#  name           = "emqx_network"
#  admin_state_up = "true"
#  mtu            = "8900"
#}

#Alhálózat létrehozása
#resource "openstack_networking_subnet_v2" "emqx_subnet" {
#  network_id = "${openstack_networking_network_v2.emqx_network.id}"
#  cidr       = "192.168.1.0/24"
#  name       = "emqx_subnet"
#}

#Floating IP létrehozása
#resouce "openstack_networking_floatingip_v2" "external" {
#  pool = "ext-net"
#}


#Controll node létrehozása
#resource "openstack_compute_instance_v2" "control" {
 # depends_on = [openstack_networking_subnet_v2.emqx_subnet]
#  name            = "EMQX_Controll"
#  flavor_name       = "m2.medium"
#  key_pair        = "ansible"
#  security_groups = ["default","${openstack_networking_secgroup_v2.terraform_emqx_master.name}"]
#  block_device {
#    uuid                  = "8b693880-6273-44b0-91ab-f0e9403dff69"
#    source_type           = "image"
#    volume_size           = 25
#    boot_index            = 0
#    destination_type      = "volume"
#    delete_on_termination = true
#  }

  network {
    name = "default"
  }
  

}

#Floating IP kiosztása a Controll Node részére
resource "openstack_compute_floatingip_associate_v2" "fip_1" {
  floating_ip = "193.225.250.157"
  instance_id = openstack_compute_instance_v2.basic[0].id
  fixed_ip = openstack_compute_instance_v2.basic[0].network.0.fixed_ip_v4
}

#Cluster létrehozása
resource "openstack_compute_instance_v2" "basic" {
  #depends_on = [openstack_networking_subnet_v2.emqx_subnet]
  count = 3
  name            = "EMQX_NODE-${count.index}"
  flavor_name       = "m2.medium"
  key_pair = "ansible"
  security_groups = ["default","${openstack_networking_secgroup_v2.terraform_emqx_master.name}"]

  block_device {
    uuid                  = "8b693880-6273-44b0-91ab-f0e9403dff69"
    source_type           = "image"
    volume_size           = 25
    boot_index            = 0
    destination_type      = "volume"
    delete_on_termination = true
  }

  network {
    name = "default"
  }
  
}

#MasterNode Ansible
resource "null_resource" "masterNode" {
provisioner "local-exec" {
    working_dir = "./"
    command = <<EOF
                ANSIBLE_HOST_KEY_CHECKING=False ANSIBLE_SSH_RETRIES=10 \
                ansible-playbook -u ubuntu -i '${openstack_compute_floatingip_associate_v2.fip_1.floating_ip},' main.yaml \
                --extra-vars \
                'IPADDRESS=${openstack_compute_instance_v2.basic[0].access_ip_v4} \
                 WORKER="false"\
                 masterIP=${openstack_compute_instance_v2.basic[0].access_ip_v4}'
    EOF
  }

}

#resource "time_sleep" "wait_15_sec"{
#depends_on = [null_resource.masterNode]
#create_duration = "15s"
#}


resource "null_resource" "worker1" {
depends_on = [null_resource.masterNode]
provisioner "local-exec" {
    working_dir = "./"
    command = <<EOF
                ANSIBLE_HOST_KEY_CHECKING=False ANSIBLE_SSH_RETRIES=10 \
                ansible-playbook -u ubuntu -i '${openstack_compute_instance_v2.basic[1].access_ip_v4},' main.yaml \
                --extra-vars \
                'IPADDRESS=${openstack_compute_instance_v2.basic[1].access_ip_v4} \
                masterIP=${openstack_compute_instance_v2.basic[0].access_ip_v4} \
                WORKER="true"' \
                --ssh-common-args '-o ProxyCommand="ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -W %h:%p \
                ubuntu@${openstack_compute_floatingip_associate_v2.fip_1.floating_ip}"'
    EOF
  }

}




resource "null_resource" "worker2" {
depends_on = [null_resource.worker1]
provisioner "local-exec" {
    working_dir = "./"
    command = <<EOF
                ANSIBLE_HOST_KEY_CHECKING=False ANSIBLE_SSH_RETRIES=10 \
                ansible-playbook -u ubuntu -i '${openstack_compute_instance_v2.basic[2].access_ip_v4},' main.yaml \
                --extra-vars \
                'IPADDRESS=${openstack_compute_instance_v2.basic[2].access_ip_v4} \
                masterIP=${openstack_compute_instance_v2.basic[0].access_ip_v4} \
                WORKER="true"' \
                --ssh-common-args '-o ProxyCommand="ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -W %h:%p \
                ubuntu@${openstack_compute_floatingip_associate_v2.fip_1.floating_ip}"'
    EOF
  }

}








output "Cluster" {
  value = openstack_compute_instance_v2.basic.*.network.0.fixed_ip_v4
}

output "Floating"{
  value = openstack_compute_floatingip_associate_v2.fip_1.floating_ip
}


# Create an inventory file to be used by subsequent Ansible playbook runs. 
resource "null_resource" "create_inventory" {

  # Print the group names and IP address of Horovod Master into the invetory file
  provisioner "local-exec" {
    working_dir = "./"
    command = "rm -f inventory && echo [nodes] >> inventory"

  }

  depends_on = [
    openstack_compute_instance_v2.basic
  ]
}

# Add every Horovod Worker to the inventory
resource "null_resource" "fill_inventory" {
  count = 3

  # Print the IP address of Horovod Worker(s) into the invetory file
  provisioner "local-exec" {
    working_dir = "./"
    command = "echo $CURRENTIP >> inventory"

    environment = {
      CURRENTIP = openstack_compute_instance_v2.basic[count.index].network.0.fixed_ip_v4
    }
  }

  depends_on = [
    null_resource.create_inventory,
  ]
}




#-----JUNK-----
#resource "openstack_compute_instance_v2" "basic"{
#        name = "tesztVM"
#        image_id = "8b693880-6273-44b0-91ab-f0e9403dff69"
#       flavor_name = "m2.medium"
#		security_groups = ["default"]
#
#}


#network {
#	name = "4e05d9fc-963a-476c-9a55-d78b5a6907b0"
#	}

#resource "openstack_blockstorage_volume_v3" "volume_1" {
#  #region      = "RegionOne"
#  name        = "volume_1"
#  description = "first test volume"
#  size        = 40
#}

#resource "openstack_compute_volume_attach_v2" "attach_1" {
#  instance_id = "${openstack_compute_instance_v2.basic.id}"
#  volume_id   = "${openstack_blockstorage_volume_v3.volume_1.id}"
#}
