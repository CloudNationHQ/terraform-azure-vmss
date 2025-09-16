# Changelog

## [2.1.0](https://github.com/CloudNationHQ/terraform-azure-vmss/compare/v2.0.1...v2.1.0) (2025-09-16)


### Features

* fix some faulty type definitions and small code refactor ([#70](https://github.com/CloudNationHQ/terraform-azure-vmss/issues/70)) ([bbc5ad7](https://github.com/CloudNationHQ/terraform-azure-vmss/commit/bbc5ad77108e4a1019c3863684bc47687742ac59))

## [2.0.1](https://github.com/CloudNationHQ/terraform-azure-vmss/compare/v2.0.0...v2.0.1) (2025-08-18)


### Bug Fixes

* update variable types for settings and protected_settings in vmss ([#65](https://github.com/CloudNationHQ/terraform-azure-vmss/issues/65)) ([ca9ef8f](https://github.com/CloudNationHQ/terraform-azure-vmss/commit/ca9ef8f9679bb4faecb08840c015086545a8b372))

## [2.0.0](https://github.com/CloudNationHQ/terraform-azure-vmss/compare/v1.3.0...v2.0.0) (2025-08-11)


### ⚠ BREAKING CHANGES

* refactor module, add type definitions ([#62](https://github.com/CloudNationHQ/terraform-azure-vmss/issues/62))

### Features

* **deps:** bump github.com/gruntwork-io/terratest in /tests ([#54](https://github.com/CloudNationHQ/terraform-azure-vmss/issues/54)) ([4194348](https://github.com/CloudNationHQ/terraform-azure-vmss/commit/41943484dd8ddf59870201198021eb649e719e46))
* refactor module, add type definitions ([#62](https://github.com/CloudNationHQ/terraform-azure-vmss/issues/62)) ([3f89743](https://github.com/CloudNationHQ/terraform-azure-vmss/commit/3f8974366baed56d9605b0d33f3ed24963ebd55f))

## [1.3.0](https://github.com/CloudNationHQ/terraform-azure-vmss/compare/v1.2.0...v1.3.0) (2025-01-20)


### Features

* **deps:** bump github.com/gruntwork-io/terratest in /tests ([#48](https://github.com/CloudNationHQ/terraform-azure-vmss/issues/48)) ([7b1d359](https://github.com/CloudNationHQ/terraform-azure-vmss/commit/7b1d359060f495692d9f4e1a8560fb597632f0de))
* **deps:** bump golang.org/x/crypto from 0.29.0 to 0.31.0 in /tests ([#51](https://github.com/CloudNationHQ/terraform-azure-vmss/issues/51)) ([ea97ea4](https://github.com/CloudNationHQ/terraform-azure-vmss/commit/ea97ea401916a8f104770eef1edb18cc2cdaf4f4))
* **deps:** bump golang.org/x/net from 0.31.0 to 0.33.0 in /tests ([#52](https://github.com/CloudNationHQ/terraform-azure-vmss/issues/52)) ([b5762dd](https://github.com/CloudNationHQ/terraform-azure-vmss/commit/b5762dd0434ac6c915931261a68fa56846597e2c))
* remove temporary files when deployment tests fails ([#49](https://github.com/CloudNationHQ/terraform-azure-vmss/issues/49)) ([7c539bc](https://github.com/CloudNationHQ/terraform-azure-vmss/commit/7c539bca227920ea6f4dd1dc05d72cdee62e6ada))

## [1.2.0](https://github.com/CloudNationHQ/terraform-azure-vmss/compare/v1.1.0...v1.2.0) (2024-11-11)


### Features

* enhance testing with sequential, parallel modes and flags for exceptions and skip-destroy ([#45](https://github.com/CloudNationHQ/terraform-azure-vmss/issues/45)) ([c2c29b8](https://github.com/CloudNationHQ/terraform-azure-vmss/commit/c2c29b81a2fa4182cf9f2340c076f90bafea304b))

## [1.1.0](https://github.com/CloudNationHQ/terraform-azure-vmss/compare/v1.0.0...v1.1.0) (2024-10-11)


### Features

* auto generated docs and refine makefile ([#43](https://github.com/CloudNationHQ/terraform-azure-vmss/issues/43)) ([b3bd4eb](https://github.com/CloudNationHQ/terraform-azure-vmss/commit/b3bd4eb1745fc8313c46a23bad78f26237e5ab38))

## [1.0.0](https://github.com/CloudNationHQ/terraform-azure-vmss/compare/v0.8.0...v1.0.0) (2024-10-03)


### ⚠ BREAKING CHANGES

* data structure has changed due to renaming of properties.

### Features

* aligned several properties ([#39](https://github.com/CloudNationHQ/terraform-azure-vmss/issues/39)) ([8e6b5b4](https://github.com/CloudNationHQ/terraform-azure-vmss/commit/8e6b5b4c0d16535344b20011a0289335c8c84800))

### Upgrade from v0.8.0 to v1.0.0:

- Update module reference to: `version = "~> 1.0"`
- Rename properties in vmss object:
  - resourcegroup -> resource_group
- Rename variable (optional):
  - resourcegroup -> resource_group

## [0.8.0](https://github.com/CloudNationHQ/terraform-azure-vmss/compare/v0.7.0...v0.8.0) (2024-09-16)


### Features

* increase random version constrant to ~&gt; 3.6 ([#36](https://github.com/CloudNationHQ/terraform-azure-vmss/issues/36)) ([5b23869](https://github.com/CloudNationHQ/terraform-azure-vmss/commit/5b238695f9b091036ef39d0a783b1e879b126a1e))

## [0.7.0](https://github.com/CloudNationHQ/terraform-azure-vmss/compare/v0.6.0...v0.7.0) (2024-08-28)


### Features

* update documentation ([#33](https://github.com/CloudNationHQ/terraform-azure-vmss/issues/33)) ([f2b42d2](https://github.com/CloudNationHQ/terraform-azure-vmss/commit/f2b42d2c4f0dec4f99cbfc2d377f8e4ddc0d056e))

## [0.6.0](https://github.com/CloudNationHQ/terraform-azure-vmss/compare/v0.5.0...v0.6.0) (2024-08-28)


### Features

* **deps:** bump github.com/gruntwork-io/terratest in /tests ([#32](https://github.com/CloudNationHQ/terraform-azure-vmss/issues/32)) ([c84a644](https://github.com/CloudNationHQ/terraform-azure-vmss/commit/c84a644a8e1929065f0cbf0590da21e0bbe65da9))
* update contribution docs ([#30](https://github.com/CloudNationHQ/terraform-azure-vmss/issues/30)) ([025a336](https://github.com/CloudNationHQ/terraform-azure-vmss/commit/025a33679c49e41594025e9e9f0fda7184a881fa))

## [0.5.0](https://github.com/CloudNationHQ/terraform-azure-vmss/compare/v0.4.0...v0.5.0) (2024-07-02)


### Features

* add issue template ([#28](https://github.com/CloudNationHQ/terraform-azure-vmss/issues/28)) ([90b0276](https://github.com/CloudNationHQ/terraform-azure-vmss/commit/90b02765d7a75781a8a9b99bd5e0012c4851a6ff))
* **deps:** bump github.com/Azure/azure-sdk-for-go/sdk/azidentity ([#24](https://github.com/CloudNationHQ/terraform-azure-vmss/issues/24)) ([2c5d4e6](https://github.com/CloudNationHQ/terraform-azure-vmss/commit/2c5d4e61253528df560f0c8fa0cce740b6d0bc89))
* **deps:** bump github.com/Azure/azure-sdk-for-go/sdk/azidentity ([#27](https://github.com/CloudNationHQ/terraform-azure-vmss/issues/27)) ([972b08c](https://github.com/CloudNationHQ/terraform-azure-vmss/commit/972b08ce3062b80065f65f00f1bcc729e6d4758a))
* **deps:** bump github.com/gruntwork-io/terratest in /tests ([#21](https://github.com/CloudNationHQ/terraform-azure-vmss/issues/21)) ([33b8f7b](https://github.com/CloudNationHQ/terraform-azure-vmss/commit/33b8f7bd4eb14b660e098e9f596986cc6f3a72d4))
* **deps:** bump github.com/gruntwork-io/terratest in /tests ([#26](https://github.com/CloudNationHQ/terraform-azure-vmss/issues/26)) ([77d0d9e](https://github.com/CloudNationHQ/terraform-azure-vmss/commit/77d0d9eb722496527abf6f6012c1e41a12e0abb6))
* **deps:** bump github.com/hashicorp/go-getter in /tests ([#25](https://github.com/CloudNationHQ/terraform-azure-vmss/issues/25)) ([dcafc47](https://github.com/CloudNationHQ/terraform-azure-vmss/commit/dcafc478532fba8a3b84484f24464747c1354af3))
* **deps:** bump golang.org/x/net from 0.19.0 to 0.23.0 in /tests ([#18](https://github.com/CloudNationHQ/terraform-azure-vmss/issues/18)) ([ff462a3](https://github.com/CloudNationHQ/terraform-azure-vmss/commit/ff462a34224cfc4e90fc6854fe0a1e9c0ecc0e21))

## [0.4.0](https://github.com/CloudNationHQ/terraform-azure-vmss/compare/v0.3.0...v0.4.0) (2024-06-07)


### Features

* add pull request template ([#22](https://github.com/CloudNationHQ/terraform-azure-vmss/issues/22)) ([ac4f783](https://github.com/CloudNationHQ/terraform-azure-vmss/commit/ac4f7836b0675689119b16043b51621b3cf8c6dc))
* **deps:** bump github.com/Azure/azure-sdk-for-go/sdk/azidentity ([#17](https://github.com/CloudNationHQ/terraform-azure-vmss/issues/17)) ([f62fa78](https://github.com/CloudNationHQ/terraform-azure-vmss/commit/f62fa783121f00daacef758f76dbc9c8c36b4875))
* **deps:** bump github.com/hashicorp/go-getter in /tests ([#19](https://github.com/CloudNationHQ/terraform-azure-vmss/issues/19)) ([c7dfd17](https://github.com/CloudNationHQ/terraform-azure-vmss/commit/c7dfd1732cee9f21bfff4dc8bbe2e5e343a831bd))

## [0.3.0](https://github.com/CloudNationHQ/terraform-azure-vmss/compare/v0.2.0...v0.3.0) (2024-03-26)


### Features

* **deps:** bump github.com/Azure/azure-sdk-for-go/sdk/azidentity ([#10](https://github.com/CloudNationHQ/terraform-azure-vmss/issues/10)) ([e93b1ba](https://github.com/CloudNationHQ/terraform-azure-vmss/commit/e93b1bafe2d14a839786596f07385b4309290a1e))
* **deps:** bump github.com/gruntwork-io/terratest in /tests ([#14](https://github.com/CloudNationHQ/terraform-azure-vmss/issues/14)) ([54f945d](https://github.com/CloudNationHQ/terraform-azure-vmss/commit/54f945d7f4bc887fc2305eae7cfa44430f55e75a))
* **deps:** bump github.com/stretchr/testify in /tests ([#11](https://github.com/CloudNationHQ/terraform-azure-vmss/issues/11)) ([9acb8c4](https://github.com/CloudNationHQ/terraform-azure-vmss/commit/9acb8c4460806e436dee8b89d57442adf13ff189))
* **deps:** bump google.golang.org/protobuf in /tests ([#13](https://github.com/CloudNationHQ/terraform-azure-vmss/issues/13)) ([a6d065d](https://github.com/CloudNationHQ/terraform-azure-vmss/commit/a6d065db4d5e5937748b6d898238f46bdad79697))
* small refactor and improvements ([#12](https://github.com/CloudNationHQ/terraform-azure-vmss/issues/12)) ([14b392e](https://github.com/CloudNationHQ/terraform-azure-vmss/commit/14b392e47da23ed970e4bc1ac0cbdbebe8ff043e))

## [0.2.0](https://github.com/CloudNationHQ/terraform-azure-vmss/compare/v0.1.0...v0.2.0) (2024-01-19)


### Features

* **deps:** Bump github.com/gruntwork-io/terratest from 0.46.8 to 0.46.9 in /tests ([#7](https://github.com/CloudNationHQ/terraform-azure-vmss/issues/7)) ([50aed3a](https://github.com/CloudNationHQ/terraform-azure-vmss/commit/50aed3ae4cc1bffe247d336c0fb47fe5547a17b0))
* **deps:** bump github.com/gruntwork-io/terratest in /tests ([#3](https://github.com/CloudNationHQ/terraform-azure-vmss/issues/3)) ([bc1032d](https://github.com/CloudNationHQ/terraform-azure-vmss/commit/bc1032d55a88ce7e99dbaedf387858b9c8ac604f))
* **deps:** bump golang.org/x/crypto from 0.14.0 to 0.17.0 in /tests ([#6](https://github.com/CloudNationHQ/terraform-azure-vmss/issues/6)) ([87ac778](https://github.com/CloudNationHQ/terraform-azure-vmss/commit/87ac778367a7bc2e441c5af783180dcb686ce5bb))
* **deps:** Bumps terratest from 0.46.7 to 0.46.8 ([#5](https://github.com/CloudNationHQ/terraform-azure-vmss/issues/5)) ([6536587](https://github.com/CloudNationHQ/terraform-azure-vmss/commit/6536587bde8f57e2c9cddb174437f8fc7f276378))
* small refactor workflows ([#8](https://github.com/CloudNationHQ/terraform-azure-vmss/issues/8)) ([09e9854](https://github.com/CloudNationHQ/terraform-azure-vmss/commit/09e985462b928730c48f58cfec247570a5e75836))

## 0.1.0 (2023-11-14)


### Features

* add initial resources ([#1](https://github.com/CloudNationHQ/terraform-azure-vmss/issues/1)) ([19d6888](https://github.com/CloudNationHQ/terraform-azure-vmss/commit/19d6888be2826993d821dba582e0eb2efdef8aa2))
