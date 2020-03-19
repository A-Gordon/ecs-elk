variable "tenant" {type = string}
variable "environment" {type = string}
variable "region" {type = string}
variable "azs" {type = list}
variable "private_subnets" {type = list}
variable "public_subnets" {type = list}
variable "ssh_public_key" {type = string}