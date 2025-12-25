variable "aws_region" {
  default = "ap-south-1"
}

variable "image_uri" {
  description = "Full ECR image URI with tag"
  type        = string
}

variable "db_name" {
  default = "strapi_db"
}

variable "db_username" {
  default = "strapi"
}

variable "db_password" {
  sensitive = true
}

variable "app_keys" {
  description = "Strapi APP_KEYS (comma-separated)"
  type        = string
  sensitive   = true
  default     = "oKlNI1DfvTJywAvugUa1rg==,xGr2Nrwr+/kG211XF7/tjw==,NLBKi6F8ERkj0gH+QON3Aw==,Uaf0qzbPhhzkXxVyxcIelg=="
}

variable "api_token_salt" {
  description = "Strapi API_TOKEN_SALT"
  type        = string
  sensitive   = true
  default     = "ciO3EBUMNcuOHK2L8kmtZw=="
}

variable "admin_jwt_secret" {
  description = "Strapi ADMIN_JWT_SECRET"
  type        = string
  sensitive   = true
  default     = "kekb3bxKXne/JcXySKXcHA=="
}

variable "jwt_secret" {
  description = "Strapi JWT_SECRET"
  type        = string
  sensitive   = true
  default     = "aj3wJfxX6ttx0mq3l1zYGA=="
}

variable "transfer_token_salt" {
  description = "Strapi TRANSFER_TOKEN_SALT"
  type        = string
  sensitive   = true
  default     = "BdDYGah1gFByG3ev19vREA=="
}
