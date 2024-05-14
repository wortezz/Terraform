locals {
  tag_name = var.use_locals ? "forum" : var.bucket_name  
}

# module "s3" {
#   source = "./modules/s3"
#   bucket_name = "${data.aws_caller_identity.current.account_id}-my-tf-test-bucket-s3"
#   use_locals = true
# }

module "table_authors" {
  source = "./modules/dynamodb"
  context = module.label.context
  name = "authors"
}

module "table_courses" {
  source = "./modules/dynamodb"
  context = module.label.context
  name = "courses"
}

# resource "aws_s3_bucket" "this" {
#   bucket = module.label.id
#   tags = module.label_s3.tags
# }

module "lambdas" {
  source = "./modules/lambda"
  context = module.label.context
  table_authors_name = module.table_authors.id
  role_get_all_authors_arn = module.iam.role_get_all_authors_arn
  table_courses_name = module.table_courses.id
  role_get_all_courses_arn = module.iam.role_get_all_courses_arn
  role_update_course_arn = module.iam.role_update_course_arn
  role_save_course_arn = module.iam.role_save_course_arn
  role_delete_course_arn = module.iam.role_delete_course_arn
  role_get_course_arn = module.iam.role_get_course_arn
  aws_api_gateway_rest_api_execution_arn = aws_api_gateway_rest_api.this.execution_arn
  logging_log_group_authors = module.cloudwatch.cloudwatch_log_group_get_all_authors_name
  logging_log_group_courses = module.cloudwatch.cloudwatch_log_group_get_all_courses_name
  }

module "iam" {
  source = "./modules/iam"
  context = module.label.context
  table_authors_arn = module.table_authors.arn
  cloudwatch_log_group_get_all_authors_arn = module.cloudwatch.cloudwatch_log_group_get_all_authors_arn
  table_courses_arn = module.table_courses.arn
  cloudwatch_log_group_get_all_courses_arn = module.cloudwatch.cloudwatch_log_group_get_all_courses_arn
  cloudwatch_log_group_update_course_arn = module.cloudwatch.cloudwatch_log_group_update_course_arn
  cloudwatch_log_group_save_course_arn = module.cloudwatch.cloudwatch_log_group_save_course_arn
  cloudwatch_log_group_delete_course_arn = module.cloudwatch.cloudwatch_log_group_delete_course_arn
  cloudwatch_log_group_get_course_arn = module.cloudwatch.cloudwatch_log_group_get_course_arn
}

module "cloudwatch" {
  source = "./modules/cloudwatch"
  context = module.label.context
}