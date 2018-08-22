# Copyright 2017 Google Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

variable region {
  default = "us-west1"
}

variable zone {
  default = "us-west1-b"
}

variable network_name {
  default = "tf-gke-named-port"
}

provider google {
  region = "${var.region}"
}

data "google_client_config" "current" {}

resource "google_compute_network" "default" {
  name                    = "${var.network_name}"
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "default" {
  name                     = "${var.network_name}"
  ip_cidr_range            = "10.127.0.0/20"
  network                  = "${google_compute_network.default.self_link}"
  region                   = "${var.region}"
  private_ip_google_access = true
}

data "google_container_engine_versions" "default" {
  zone = "${var.zone}"
}

resource "google_container_cluster" "default" {
  name               = "tf-gke-named-port"
  zone               = "${var.zone}"
  initial_node_count = 3
  min_master_version = "${data.google_container_engine_versions.default.latest_node_version}"
  network            = "${google_compute_subnetwork.default.name}"
  subnetwork         = "${google_compute_subnetwork.default.name}"
}

module "named-port" {
  source         = "../../"
  instance_group = "${element(google_container_cluster.default.instance_group_urls, 0)}"
  name           = "http"
  port           = "8080"
}

output "network" {
  value = "${google_compute_subnetwork.default.network}"
}

output "subnetwork_name" {
  value = "${google_compute_subnetwork.default.name}"
}

output "cluster_name" {
  value = "${google_container_cluster.default.name}"
}

output "cluster_region" {
  value = "${var.region}"
}

output "cluster_zone" {
  value = "${google_container_cluster.default.zone}"
}

output "instance_group_urls" {
  value = "${google_container_cluster.default.instance_group_urls}"
}

output "port_name" {
  value = "${module.named-port.name}"
}

output "port_number" {
  value = "${module.named-port.port}"
}
