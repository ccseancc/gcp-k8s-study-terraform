output "ipaddress" {
  description = "public ip address"
  value       = google_compute_address.main.address
}