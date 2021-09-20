variable "project" {

}

variable "credentials_file" {

}

variable "region" {
  default = "us-central1"
}

variable "zone" {
  default = "us-central1-c"
}
variable "instance_type" {
  default = "f1-micro"
}
variable "instance_os" {
  default = "debian-cloud/debian-9"
}
variable "user_ip" {}