terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.106.1"
      configuration_aliases = [
        azurerm.connectivity,
        azurerm.management,
      ]
    }
  }
}

provider "azurerm" {
  alias = "connectivity"
features {}
  subscription_id = "13ba43d9-3859-4c70-9f8d-182debaa038b"
  client_secret = "GKO8Q~DXeL2mMv0.hjbehClISxd3ZBTmBsVo2c9G"
  client_id = "ec95cbba-667b-4709-9140-68cc6739bced"
  tenant_id = "30bf9f37-d550-4878-9494-1041656caf27"
}

provider "azurerm" {
  alias = "management"
features {}
  subscription_id = "5e0ec067-7409-4ede-ae47-ed0926bad2ee"
  client_secret = "GKO8Q~DXeL2mMv0.hjbehClISxd3ZBTmBsVo2c9G"
  client_id = "ec95cbba-667b-4709-9140-68cc6739bced"
  tenant_id = "30bf9f37-d550-4878-9494-1041656caf27"
}
