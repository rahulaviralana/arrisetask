variable "instances" {
  description = "Map of EC2 instance configurations"
  type = map(object({
    instance_type = string
    volume_type   = string
    volume_size   = number
    key_name      = string
    iops          = optional(number, null)
  }))
}

variable "ami_id" {
  type = string
}

variable "environment" {
  type = string
}

variable "owner" {
  type = string
}
