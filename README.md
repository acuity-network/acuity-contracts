# Acuity Contracts
Monorepo for core smart contracts on Acuity.

## Testing

```
curl https://dapp.tools/install | sh
nix-env -f https://github.com/dapphub/dapptools/archive/master.tar.gz -iA solc-static-versions.solc_0_7_4
dapp --use solc:0.7.4 test
```
