data "oci_core_images" "OCI_JupyterLab_Images" {
  compartment_id    = var.compartment_ocid
  operating_system = "Canonical Ubuntu" 
  filter {
    name = "display_name"
    values = ["^Canonical-Ubuntu-18.04-([\\.0-9-]+)$"]
    regex = true
  } 
  shape = var.compute_shape
}

locals {
  oracle_linux = lookup(data.oci_core_images.OCI_JupyterLab_Images.images[0],"id")
}

resource "tls_private_key" "public_private_key_pair" {
  algorithm = "RSA"
}

resource "oci_core_instance" "OCI_JupyterLab_VM" {
  compartment_id        = var.compartment_ocid
  availability_domain   = lookup(data.oci_identity_availability_domains.ADs.availability_domains[var.AD - 1], "name")
  shape                 = var.compute_shape

  source_details {
    source_id     = local.oracle_linux
    source_type   = "image"
  }
  create_vnic_details {
    subnet_id         = oci_core_subnet.OCI_JupyterLab_SN.id
    display_name      = "primary_vnic"
    assign_public_ip  = true
  }
  metadata = {
    ssh_authorized_keys = tls_private_key.public_private_key_pair.public_key_openssh
  }
  timeouts {
    create = "5m"
  }
  display_name = "OCI_JupyterLab_VM"
}

resource "null_resource" "remote-exec" {
  # development executed on every apply
  triggers = {timestamp = timestamp()}
  connection {
    agent       = false
    timeout     = "30m"
    host        = oci_core_instance.OCI_JupyterLab_VM.public_ip
    user        = var.opc_user_name
    private_key = tls_private_key.public_private_key_pair.private_key_pem
  }
  # copy install script
  provisioner "file" {
    source      = "script.sh"
    destination = "/tmp/script.sh"
  }
  # execute install script
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/script.sh",
      "/tmp/script.sh",
    ]
  }
}

resource "local_file" "key_public" {
    content  = tls_private_key.public_private_key_pair.public_key_openssh
    filename = "keys/key_public.pem"
    file_permission = "400"
}

resource "local_file" "key_private" {
    content  = tls_private_key.public_private_key_pair.private_key_pem
    filename = "keys/key_private.pem"
    file_permission = "400"
}