# Homebrew tap for Simulator Broker

[![CI](https://github.com/fiveonecode/homebrew-simulator-broker/actions/workflows/ci.yml/badge.svg)](https://github.com/fiveonecode/homebrew-simulator-broker/actions/workflows/ci.yml)

```bash
brew install fiveonecode/simulator-broker/simbroker
```

Homebrew maps the tap name `fiveonecode/simulator-broker` to this GitHub
repository, `fiveonecode/homebrew-simulator-broker`. It does not clone
the product repository.

Formula and cask source of truth is
[`fiveonecode/simulator-broker`](https://github.com/fiveonecode/simulator-broker)
under `Formula/` and `Casks/`. A scheduled workflow copies those paths
here only when `Formula/simbroker.rb` exists on product `main`.

Pull requests and pushes to `main` run `script/verify.sh`: `brew style`,
`brew audit --strict`, formula `--online` audit, and cask `--online` audit
that allows only the known Alpha pre-release and empty-livecheck findings.
The same command is the origin Autopilot verify contract in `autopilot.yml`.

The operator app cask installs the signed, notarized
`Simulator-Broker-<version>.zip` from the matching product GitHub Release.
