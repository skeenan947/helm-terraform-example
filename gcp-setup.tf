// Configure the Google Cloud provider
provider "google" {
  credentials = "${file("account.json")}"
  project     = "vidcdn-201105"
  region      = "us-west1"
}
data "google_client_config" "current" {}
