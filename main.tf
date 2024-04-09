resource "aws_instance" "openstack_host" {
  ami           = "ami-068cf3d51efeb20d6"
  instance_type = "t3.2xlarge"
  key_name      = "openstack_lab" # replace with actual key name

  root_block_device {
    volume_size = 100
    volume_type = "gp3"
  }

  network_interface {
    network_interface_id = aws_network_interface.management.id
    device_index         = 0
  }

  provisioner "file" {
    source      = "${path.module}/scripts/prep_aio_host.sh"
    destination = "/home/ubuntu/prep_aio_host.sh"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("${path.module}/openstack_lab.pem")
      host        = self.public_ip
    }
  }

  provisioner "file" {
    source      = "${path.module}/globals.tmpl.yml"
    destination = "/home/ubuntu/globals.tmpl.yml"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("${path.module}/openstack_lab.pem")
      host        = self.public_ip
    }
  }

  provisioner "file" {
    source      = "${path.module}/scripts/deploy_kolla.sh"
    destination = "/home/ubuntu/deploy_kolla.sh"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("${path.module}/openstack_lab.pem")
      host        = self.public_ip
    }
  }

  provisioner "file" {
    source      = "${path.module}/scripts/install_kolla_deps.sh"
    destination = "/home/ubuntu/install_kolla_deps.sh"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("${path.module}/openstack_lab.pem")
      host        = self.public_ip
    }
  }

  provisioner "file" {
    source      = "${path.module}/scripts/setup_kolla.sh"
    destination = "/home/ubuntu/setup_kolla.sh"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("${path.module}/openstack_lab.pem")
      host        = self.public_ip
    }
  }

  provisioner "file" {
    source      = "${path.module}/scripts/setup_wrapper.sh"
    destination = "/home/ubuntu/setup_wrapper.sh"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("${path.module}/openstack_lab.pem")
      host        = self.public_ip
    }
  }
  provisioner "remote-exec" {
    script = "${path.module}/scripts/setup_wrapper.sh"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("${path.module}/openstack_lab.pem")
      host        = self.public_ip
    }
  }

  # network_interface {
  #   network_interface_id = aws_network_interface.management.id
  #   device_index         = 0
  # }

  tags = {
    Name = "OpenStackKollaHost"
  }
}

resource "aws_network_interface" "management" {
  subnet_id       = aws_subnet.management_subnet.id
  security_groups = [aws_security_group.allow_all_home.id]
  private_ips     = ["10.0.1.10"]
}

# resource "aws_network_interface_attachment" "management_nic_attachment" {
#   instance_id          = aws_instance.openstack_host.id
#   network_interface_id = aws_network_interface.management.id
#   device_index         = 0
# }

resource "aws_eip" "openstack_host" {
  #vpc               = true
  network_interface = aws_network_interface.management.id
  depends_on = [
    aws_network_interface.management,
  ]
}

resource "aws_network_interface" "neutron_external" {
  #subnet_id       = aws_subnet.neutron_external_subnet.id
  subnet_id       = aws_subnet.management_subnet.id
  security_groups = [aws_security_group.neutron_external_sg.id]
}

resource "aws_network_interface_attachment" "attach_neutron_external" {
  instance_id          = aws_instance.openstack_host.id
  network_interface_id = aws_network_interface.neutron_external.id
  device_index         = 1
}

