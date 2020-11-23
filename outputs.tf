output "connection_normal" {
    value = "ssh -i keys/key_private.pem ${var.opc_user_name}@${oci_core_instance.OCI_JupyterLab_VM.public_ip}"
    description = "simple connection to oci compute instance"

}
output "connection_port_forwarding" {
  value = "ssh ssh -o IdentitiesOnly=yes -i keys/key_private.pem -L ${var.local_jupyter_port}:localhost:8888 ${var.opc_user_name}@${oci_core_instance.OCI_JupyterLab_VM.public_ip}"
  description = "connect to oci compute instance with port forwarding"
}