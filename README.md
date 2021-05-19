# Acuity Contracts
Monorepo for core smart contracts on Acuity.

Original repos:
* https://github.com/acuity-social/mix-account-items
* https://github.com/acuity-social/mix-account-profile
* https://github.com/acuity-social/mix-account
* https://github.com/acuity-social/mix-item-dag
* https://github.com/acuity-social/mix-item-mentions
* https://github.com/acuity-social/mix-item-store
* https://github.com/acuity-social/mix-item-topics
* https://github.com/acuity-social/mix-reactions
* https://github.com/acuity-social/mix-token
* https://github.com/acuity-social/mix-trusted-accounts

## Testing

```
curl https://dapp.tools/install | sh
nix-env -f https://github.com/dapphub/dapptools/archive/master.tar.gz -iA solc-static-versions.solc_0_7_4
dapp --use solc:0.7.4 test
```
