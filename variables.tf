variable "project" {
  default = "homework"
}
variable "credentials_file" {
  default = "./credentials.json"
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
variable "user_ip" {

}

variable "mig_size" {
  default = 2
}

variable "script" {

}

variable "sql-user" {

}
variable "sql-password" {

}