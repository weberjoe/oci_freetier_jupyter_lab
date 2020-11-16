variable "tenancy_ocid" {}
variable "region" {}
variable "compartment_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key_path" {}
variable "opc_user_name" {
  default = "ubuntu"
}
variable "AD" {
  default = "2"
}
variable "local_jupyter_port" {
  default = 8882
}