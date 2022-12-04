variable "region" {
  description = "region"
  type        = string
  default     = "ap-southeast-1"
}
variable "ec2_security_group_name" {
  description = "Security group name for web server EC2 instance"
  type        = string
  default     = "demo-docker-sg"
}
variable "ec2_security_group_description" {
  description = "Security group description for web server EC2 instance"
  type        = string
  default     = "Allow traffic for docker app and ssh"
}
variable "ec2_instance_name" {
  description = "Name for web server EC2 instance"
  type        = string
  default     = "web_server"
}
variable "ec2_instance_type" {
  description = "Instance type for web server EC2 instance"
  type        = string
  default     = "t2.micro"
}
variable "keypair_name" {
  description = "keypair_name"
  type        = string
  default     = ""
}
