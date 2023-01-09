terraform {
  backend "remote" {
    organization = "robbins"
    workspaces {
        name = "robbins-page"
    }
  }
}
