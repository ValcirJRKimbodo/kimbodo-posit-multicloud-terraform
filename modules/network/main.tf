/* -----------------------------------------------------------------------------
 *  NETWORK MODULE
 *  Creates a custom-mode VPC and a subnet with primary + secondary ranges
 * -----------------------------------------------------------------------------
 */
resource "google_compute_network" "this" {
  name                    = var.vpc_name
  auto_create_subnetworks = false
  description             = var.vpc_description
  mtu                     = 1460
  routing_mode            = "REGIONAL"
}

resource "google_compute_subnetwork" "this" {
  name          = var.subnet_name
  ip_cidr_range = var.primary_cidr
  network       = google_compute_network.this.id
  region        = var.region

  private_ip_google_access = true

  secondary_ip_range {
    range_name    = var.pods_range_name
    ip_cidr_range = var.pods_cidr
  }
}
