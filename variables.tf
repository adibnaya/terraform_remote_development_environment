variable "host_os" {
  description = "The host OS of the machine running Terraform"
  type        = string
  default     = "windows"
}

variable "local_ip" {
  description = "The local IP address to allow SSH access"
  type        = string
  default     = "0.0.0.0/0"
}

variable "key_name" {
  description = "The name of the AWS key pair to use for SSH access"
  type        = string
  default     = "aws_key"
}

variable "key_path" {
  description = "The path to the private key file used for SSH access"
  type        = string
  default     = "~/.ssh"
}