resource "oci_core_vcn" "Cloud_Native_Training_VCN" {
  cidr_block      = "10.0.0.0/16"
  compartment_id  = var.compartment_ocid

  display_name    = "Cloud Native Training VCN"
}

resource "oci_core_internet_gateway" "Cloud_Native_Training_VCN" {
  compartment_id  = var.compartment_ocid
  vcn_id          = oci_core_vcn.Cloud_Native_Training_VCN.id

  display_name    = "Cloud Native Training IGW"
}

resource "oci_core_route_table" "Cloud_Native_Training_RT" {
  compartment_id  = var.compartment_ocid
  vcn_id          = oci_core_vcn.Cloud_Native_Training_VCN.id
  route_rules {
    destination       = "0.0.0.0/0"
    network_entity_id = oci_core_internet_gateway.Cloud_Native_Training_VCN.id
  }

  display_name    = "Cloud Native Training RT"
}

resource "oci_core_subnet" "Cloud_Native_Training_SN" {
  compartment_id    = var.compartment_ocid
  vcn_id            = oci_core_vcn.Cloud_Native_Training_VCN.id
  cidr_block        = "10.0.1.0/24"
  security_list_ids = [oci_core_security_list.Cloud_Native_Training_SL.id]
  route_table_id    = oci_core_route_table.Cloud_Native_Training_RT.id

  display_name    = "Cloud Native Training SN"
  availability_domain = lookup(data.oci_identity_availability_domains.ADs.availability_domains[var.AD - 1], "name")
}

resource "oci_core_security_list" "Cloud_Native_Training_SL" {
  compartment_id  = var.compartment_ocid
  vcn_id          = oci_core_vcn.Cloud_Native_Training_VCN.id

  egress_security_rules { 
    destination = "0.0.0.0/0" 
    protocol = "all" 
  }

  ingress_security_rules { 
    protocol = "6"
    source = "0.0.0.0/0"
    tcp_options { 
      max = 22
      min = 22 
    }
  }

  ingress_security_rules {
    protocol = "6"
    source = "0.0.0.0/0"
    tcp_options { 
      max = 80
      min = 80 
    }
  }

  display_name   = "training_sl"
}


