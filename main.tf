data "external" "named_ports" {
  program = ["${path.module}/add_named_ports.sh"]

  query = {
    instance_group = "${var.instance_group}"
    name           = "${var.name}"
    port           = "${var.port}"
  }
}
