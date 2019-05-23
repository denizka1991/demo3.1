###################
### GKE Cluster ###
###################
resource "google_container_cluster" "k8s_dev_cluster" {
  name               = "k8s-dev-cluster"
  region               = "${var.region}"
  initial_node_count = 2

  addons_config {
    network_policy_config {
      disabled = true
    }
  }

  master_auth {
    username = "${var.username}"
    password = "${var.password}"
  }

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/trace.append",
      "https://www.googleapis.com/auth/compute",
    ]
  }
}

######################
### Output for K8S ###
######################
output "client_certificate" {
  value     = "${google_container_cluster.k8s_dev_cluster.master_auth.0.client_certificate}"
  sensitive = true
}

output "client_key" {
  value     = "${google_container_cluster.k8s_dev_cluster.master_auth.0.client_key}"
  sensitive = true
}

output "cluster_ca_certificate" {
  value     = "${google_container_cluster.k8s_dev_cluster.master_auth.0.cluster_ca_certificate}"
  sensitive = true
}

output "host" {
  value     = "${google_container_cluster.k8s_dev_cluster.endpoint}"
  sensitive = true
}

resource "null_resource" "kubeconfig" {
provisioner "local-exec" {
command = <<LOCAL_EXEC
export KUBECONFIG="/home/jenkins/.kube/config"
kubectl config set-cluster k8s_dev_cluster-cluster --server="k8s_dev_cluster" --insecure-skip-tls-verify=true
kubectl config set users.default-admin.client-certificate-data ${base64encode(google_container_cluster.k8s_dev_cluster.master_auth.0.client_certificate)}
kubectl config set users.default-admin.client-key-data ${base64encode(google_container_cluster.k8s_dev_cluster.master_auth.0.client_key)}
kubectl config set-context k8s_dev_cluster-context --cluster=k8s_dev_cluster-cluster --user=default-admin
kubectl config use-context k8s_dev_cluster-context
LOCAL_EXEC
}
}
