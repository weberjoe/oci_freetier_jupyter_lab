
#### create identification env variables
``` console
touch env-vars_tenancy
chmod +x env-vars_tenancy
source env-vars
```


``` python
# get list of compartments
data "oci_identity_compartments" "comps" {
    #Required
    compartment_id = var.tenancy_ocid
}
# Output the result
output "show-comps" {
  value = data.oci_identity_compartments.comps
}
```


#### errors
'This is likely because the Always Free eligible (Micro) shapes are not available in the region where the stack was applied. Try switching to the Home Region for your tenancy.'  
-> make sure to select the right AD


#### connect to compute instance
``` python
# normal connect
ssh -i keys/key_private.pem ubuntu@158.101.171.31

# forward connect
ssh -i keys/key_private.pem -L 8883:localhost:8888 ubuntu@158.101.171.31

```



#### compute instance operating system definition
[link](https://medium.com/@gmusumeci/how-to-get-the-latest-os-image-in-oracle-cloud-infrastructure-using-terraform-f53823223968)