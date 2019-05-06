#############################
### Google Cloud Platform ###
#############################
provider "google" {
  project     = "${var.project}"
  region      = "${var.region}"
}
### Reserving External IP ###
resource "google_compute_address" "external" {
  name         = "external"
  address_type = "EXTERNAL"
  region       = "${var.region}"
}
### Output for K8S (Traefik controller) ###
output "external_ip" {
  value     = "${google_compute_address.external.address}"
  sensitive = true
}
