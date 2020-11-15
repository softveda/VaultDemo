# Create AWS IAM User hashidemo-vault
# Create policy hashidemo-vault-policy, replace ACCOUNT_ID and attach

{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "iam:AttachUserPolicy",
                "iam:CreateAccessKey",
                "iam:CreateUser",
                "iam:DeleteAccessKey",
                "iam:DeleteUser",
                "iam:DeleteUserPolicy",
                "iam:DetachUserPolicy",
                "iam:ListAccessKeys",
                "iam:ListAttachedUserPolicies",
                "iam:ListGroupsForUser",
                "iam:ListUserPolicies",
                "iam:PutUserPolicy",
                "iam:RemoveUserFromGroup"
            ],
            "Resource": [
                "arn:aws:iam::<ACCOUNT_ID>:user/vault-*"
            ]
        }
    ]
}


# get ACCESS_KEY_ID and SECRET_ACCESS_KEY
export ACCESS_KEY_ID=<ACCESS_KEY_ID>
export SECRET_ACCESS_KEY=<SECRET_ACCESS_KEY>

vault secrets enable -path=aws aws
vault write aws/config/lease lease=1h lease_max=24h

vault write aws/config/root \
    access_key=$ACCESS_KEY_ID \
    secret_key=$SECRET_ACCESS_KEY

vault write aws/roles/exporter-s3-role \
    credential_type=iam_user \
    policy_document=-<<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:*",
      "Resource": ["arn:aws:s3:::todo-exporter-bucket", "arn:aws:s3:::todo-exporter-bucket/*"]
    }
  ]
}
EOF

vault policy write exporter-policy - <<EOF
path "/secret/data/exporter/*" {
capabilities = ["read", "list"]
}
# Get credentials from the azure sql db secrets engine
path "azuresql/creds/exporter-role" {
  capabilities = [ "read" ]
}
# Get credentials from the aws secrets engine
path "aws/creds/exporter-s3-role" {
  capabilities = [ "read" ]
}
EOF

# vault lease revoke -prefix aws/creds/exporter-s3-role