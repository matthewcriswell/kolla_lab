output "instance_public_ip" {
  description = "The public IP address of the OpenStak EC2 instance."
  value       = aws_instance.openstack_host.public_ip
}
