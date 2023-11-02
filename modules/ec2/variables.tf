variable "count1" {
    default = "2"
}
variable "ins_type" {
    default = "t3.micro"
}
variable "ami" {}

variable "public_id" {
    default = "true"
}
variable "subnet_ids" {}
variable "key_name" {
}
variable "vpc_id" {}
##################################################################################################

variable "web_ingress_rules" {
    type=map(object({
        port=number
        protocol=string
        cidr_blocks=list(string)
        description=string
    }))
}