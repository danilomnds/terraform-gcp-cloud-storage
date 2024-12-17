# environment permissions such as create/update and delete were removed
resource "google_organization_iam_custom_role" "BucketReader" {
  role_id = "BucketReader"
  title   = "BucketReader"
  # ORG LEVEL
  org_id      = "<your org id>"
  description = "Custom role created by terraform."
  permissions = ["storage.buckets.get", "storage.buckets.list", "storage.objects.list" ]
}