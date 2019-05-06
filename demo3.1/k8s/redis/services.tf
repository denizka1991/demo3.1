###########################
### K8S Service - Redis ###
###########################
provider "kubernetes" {
  host                   = "${var.host}"
  username               = "${var.username}"
  password               = "${var.password}"
  client_certificate     = "${base64decode(var.client_certificate)}"
  client_key             = "${base64decode(var.client_key)}"
  cluster_ca_certificate = "${base64decode(var.cluster_ca_certificate)}"
  load_config_file = false
}
resource "kubernetes_service" "redis-master" {
  metadata {
    name = "redis-master"
    namespace = "${kubernetes_namespace.redis_space.metadata.0.name}"

    labels {
      app  = "redis"
      role = "master"
      tier = "backend"
    }
  }

  spec {
    selector {
      app  = "redis"
      role = "master"
      tier = "backend"
    }

    type = "ClusterIP"

    port {
      port        = 13666
      target_port = 6379
    }
  }
}

# output "ip_redis" {
#   value = "${kubernetes_service.redis-master.load_balancer_ingress.0.ip}"
# }