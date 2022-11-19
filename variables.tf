variable "auth_data" {
  type = object({
    credential_id = string
    credential_secret = string
    auth_url = string
  })
  sensitive = true
}
