// Displaying the WordPress Website URL.

output "site_url" {
  
  description = "URL of the WordPress website"
  value       = "http://${aws_route53_record.wordpress.name}/"
  
}
