# Creates an IAM user for ADO (Azure devops) to connect as - e.g., Authentication
resource "aws_iam_user" "ado_iam_user" {
  name = var.iam_user_name
  path = "/"

  tags = {
    BuiltBy = "Terraform"
  }
}

# Create IAM policy for the ADO IAM user 
resource "aws_iam_policy" "ado_iam_policy" {
  name = var.aws_iam_policy_name

  policy = <<POLICY
{
    "Statement": [
        {
            "Action": [
                "s3:*"
            ],
            "Effect": "Allow",
            "Resource": ""${aws_s3_bucket.state_bucket.arn}"",
            "Sid": "AllowS3Read"
        },
        {
            "Action": [
                "*"
            ],
            "Effect": "Allow",
            "Resource": "*",
            "Sid": "AllowAllPermissions"
        },
        {
            "Effect":"Allow",
            "Action": [
               "ec2:AuthorizeSecurityGroupIngress",
               "ec2:RevokeSecurityGroupIngress",
               "ec2:UpdateSecurityGroupRuleDescriptionsIngress",
               "ec2:AuthorizeSecurityGroupEgress",
               "ec2:RevokeSecurityGroupEgress",
               "ec2:UpdateSecurityGroupRuleDescriptionsEgress",
               "ec2:ModifySecurityGroupRules"
            ],
             "Resource": "arn:aws:ec2:*:*:security-group/*",
              "Condition": {
                "ArnEquals": {
                  "ec2:Vpc": "arn:aws:ec2:*:*:vpc/*"
                }
              }
            },
            {
              "Effect": "Allow",
              "Action": [
                  "ec2:DescribeSecurityGroups",
                  "ec2:DescribeSecurityGroupRules",
                  "ec2:DescribeTags"
              ],
              "Resource": "*"
            }
  ],
    
    "Version": "2012-10-17"
}
POLICY
}

# Attach IAM assume role to User
resource "aws_iam_user_policy_attachment" "iam_user_assume_attach" {
  user       = aws_iam_user.ado_iam_user.name
  policy_arn = aws_iam_policy.ado_iam_policy.arn
}