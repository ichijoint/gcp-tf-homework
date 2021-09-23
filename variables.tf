variable "project" {
  type    = string
  default = "homework"
}
# variable "credentials_file" {
#   default = "./credentials.json"
# }
variable "region" {
  type    = string
  default = "us-central1"
}
variable "zone" {
  type    = string
  default = "us-central1-c"
}
variable "instance_type" {
  type    = string
  default = "e2-medium"
}
variable "instance_os" {
  type    = string
  default = "debian-cloud/debian-9"
}
variable "user_ip" {
  type = string
}
variable "network_name" {
  type = string
}
variable "mig_size" {
  type    = number
  default = 2
}
variable "script" {
}
variable "sql-user" {
  type = string
}
variable "sql-password" {
  type = string
}
variable "ssh_public_key" {
  type = string
}