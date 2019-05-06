###########################
### K8S Service - Mongo ###
###########################
provider "kubernetes" {
  host                   = "${var.host}"
  username               = "${var.username}"
  password               = "${var.password}"
  client_certificate     = "${base64decode(var.client_certificate)}"
  client_key             = "${base64decode(var.client_key)}"
  cluster_ca_certificate = "${base64decode(var.cluster_ca_certificate)}"
  load_config_file       = false
}

resource "kubernetes_service" "mongo_master" {
  metadata {
    name = "mongo-master"
    namespace = "${kubernetes_namespace.mongo_space.metadata.0.name}"
    labels {
      app  = "mongo"
      role = "master"
      tier = "backend"
    }
  }

  spec {
    selector {
      app  = "mongo"
      role = "master"
      tier = "backend"
    }

    type = "ClusterIP"

    port {
      port        = 27017
      target_port = 27017
    }
  }
}

# output "ip" {
#   value = "${kubernetes_service.mongo-master.load_balancer_ingress.0.ip}"
# }
