resource "aws_rds_cluster_instance" "cluster_instances" {
  # count              = 1
  identifier          = "database-test-backup-instance-1"
  cluster_identifier  = "database-test-backup"
  instance_class      = "db.t3.small"
  engine              = "aurora-mysql"
  engine_version      = aws_rds_cluster.default.engine_version
  publicly_accessible = false

}

resource "aws_rds_cluster" "default" {
  cluster_identifier = "database-test-backup"
  availability_zones = ["eu-west-2a", "eu-west-2b", "eu-west-2c"]
  engine             = "aurora-mysql"
  # database_name             = "mydb"
  final_snapshot_identifier = "staging-db-testing-${random_id.snapshot_identifier.hex}"
  # final_snapshot_identifier = "db-final-staging-cluster-testing"
  skip_final_snapshot       = "false"
  # db_parameter_group_name               = "slack-db-parameter-group-prod"
  db_subnet_group_name = "db-subnetgroup-staging"

  master_username        = "Admin"
  master_password        = "barbut8charsiarUefHSFDASDF"
  vpc_security_group_ids = [aws_security_group.aurora.id]
  snapshot_identifier    = var.db_creation_from_snapshot ? data.aws_db_cluster_snapshot.development_final_snapshot.id : ""

  # timeouts {
  #   create = lookup(var.cluster_timeouts, "create", null)
  #   update = lookup(var.cluster_timeouts, "update", null)
  #   delete = lookup(var.cluster_timeouts, "delete", null)
  # }  

}


resource "aws_security_group" "aurora" {
  # count = var.create_db == true ? 1 : 0

  vpc_id      = "vpc-002efc027b911f0b9"
  name        = "db-sg-test-backup"
  description = "SG for service DB"

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "TCP"
    security_groups = ["sg-060d133bc0788ecc7", "sg-0116d76e714756b16"]
  }
}

resource "aws_db_subnet_group" "this" {
  # count = var.create_db == true ? 1 : 0

  name = "db-subnetgroup-staging-testing"
  # description = "For Aurora cluster ${var.service-name}"
  subnet_ids = [
    "subnet-028c7730c78ea283e",
    "subnet-03638fd0f57948773",
    "subnet-0d26f5694ba576667",
  ]

}

data "aws_db_cluster_snapshot" "development_final_snapshot" {
  db_cluster_identifier = "database-test-backup"
  most_recent           = true
}
# resource "aws_db_cluster_snapshot" "example" {
#   db_cluster_identifier          = aws_rds_cluster.default.id
#   db_cluster_snapshot_identifier = "resourcetestsnapshot1234"
# }
# output "snap" {
#   value = ""
# }
