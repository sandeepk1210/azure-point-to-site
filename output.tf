output "root_certificate" {
  value = tls_self_signed_cert.root_cert.cert_pem
  sensitive = true
}