/* ---------------------------------------------------------
 *  GKE MODULE (Standard mode, single node pool for MVP)
 * ---------------------------------------------------------
 */
resource "google_container_cluster" "this" {
  name       = var.cluster_name
  location   = var.region
  network    = var.network
  subnetwork = var.subnetwork

  deletion_protection = var.deletion_protection

  remove_default_node_pool = true
  initial_node_count       = 1

  network_policy {
    enabled = false
  }

  ip_allocation_policy {
    cluster_secondary_range_name  = var.pods_range_name
    services_secondary_range_name = null
  }

  release_channel {
    channel = "REGULAR"
  }

  # habilita monitoring stack do GKE (Managed Prometheus)
  monitoring_config {
    managed_prometheus {
      enabled = true
    }
  }
}

resource "google_container_node_pool" "primary" {
  name       = "primary"
  cluster    = google_container_cluster.this.name
  location   = var.region
  node_count = 2

  node_config {
    machine_type = "e2-small"
    disk_size_gb = 100
    oauth_scopes = ["https://www.googleapis.com/auth/cloud-platform"]
    metadata     = { "disable-legacy-endpoints" = "true" }
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }
}
