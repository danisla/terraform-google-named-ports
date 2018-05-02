output "instance_group" {
  description = "self_link of instance group to update"
  value       = "${var.instance_group}"
}

output "name" {
  description = "name of the port"
  value       = "${var.name}"
}

output "port" {
  description = "port number"
  value       = "${var.port}"
}

output "fingerprint" {
  description = "fingerprint from the API response"
  value       = "${lookup(data.external.named_ports.result, "fingerprint")}"
}

output "id" {
  description = "id from the API response"
  value       = "${lookup(data.external.named_ports.result, "id")}"
}
