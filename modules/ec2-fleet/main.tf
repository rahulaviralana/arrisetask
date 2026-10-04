resource "aws_instance" "fleet" {
  for_each = var.instances

  ami           = var.ami_id
  instance_type = each.value.instance_type
  key_name      = each.value.key_name

  root_block_device {
    volume_type = each.value.volume_type
    volume_size = each.value.volume_size
    iops        = each.value.iops
  }

  tags = {
    Name        = each.key
    Environment = var.environment
    Owner       = var.owner
  }

  lifecycle {
    prevent_destroy = true
  }
}
