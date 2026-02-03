# resource "null_resource" "agic_install" {
#   provisioner "local-exec" {
#     command = "kubectl apply -f https://raw.githubusercontent.com/Azure/application-gateway-kubernetes-ingress/master/deploy/agic.yaml"
#   }
# }