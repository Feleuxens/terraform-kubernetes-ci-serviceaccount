resource "kubernetes_service_account" "ci_service_account" {
  metadata {
    name = var.serviceaccount_name
  }
}

resource "kubernetes_cluster_role_binding" "ci_cluster_role_binding" {
  metadata {
    name = "ci-cluster-role-binding"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }
  subject {
    kind = "ServiceAccount"
    name = var.serviceaccount_name
  }

  depends_on = [kubernetes_service_account.ci_service_account]
}

resource "kubernetes_secret" "ci_service_account_token" {
  metadata {
    name = "ci-user-token"
    annotations = {
      "kubernetes.io/service-account.name" = var.serviceaccount_name
    }
  }
  type = "kubernetes.io/service-account-token"
}