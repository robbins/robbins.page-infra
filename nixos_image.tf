# create a random ID for the bucket
resource "random_id" "bucket" {
  byte_length = 8
}

# create a bucket to upload the image into
resource "google_storage_bucket" "nixos-images" {
  name     = "nixos-images-${random_id.bucket.hex}"
  location = "US"
}

# create a custom nixos base image 
module "nixos_image_custom" {
  source      = "github.com/tweag/terraform-nixos//google_image_nixos_custom"
  bucket_name = google_storage_bucket.nixos-images.name
  nixos_config = "${path.module}/image_nixos_custom.nix"
}
