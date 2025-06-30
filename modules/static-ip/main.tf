resource "google_compute_address" "this" {
  name   = var.name
  region = var.region
  # Para LB regional (ex.: Ingress/Traefik).  Para global, tire o 'region'.
}
