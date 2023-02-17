variable "namespace" {
  type    = string
  default = "default"
}

variable "influxdb_token" {
  type = string
}
variable "influxdb_user" {
  type = string
}
variable "influxdb_password" {
  type = string
}

variable "cassandra_user" {
  type = string
}
variable "cassandra_password" {
  type = string
}