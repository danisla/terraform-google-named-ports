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
  default = "tf-mig-named-port"
}

provider google {
  region = "${var.region}"
}

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

module "mig" {
  source             = "GoogleCloudPlatform/managed-instance-group/google"
  version            = "1.1.13"
  region             = "${var.region}"
  zone               = "${var.zone}"
  name               = "${var.network_name}"
  service_port       = 80
  service_port_name  = "http"
  size               = 1
  access_config      = []
  network            = "${google_compute_subnetwork.default.name}"
  subnetwork         = "${google_compute_subnetwork.default.name}"
  wait_for_instances = true
  http_health_check  = false
}

module "named-port" {
  source         = "../../"
  instance_group = "${module.mig.instance_group}"
  name           = "http"
  port           = "80"
}

output "port_name" {
  value = "${module.named-port.name}"
}

output "port_number" {
  value = "${module.named-port.port}"
}

output "instance_group_urls" {
  value = "${module.mig.instance_group}"
}
