# Homebrew tap for Simulator Broker

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

The operator app cask expects a signed, notarized
`Simulator-Broker-<version>.zip` on the product GitHub Release. The
current Alpha release attaches the CLI tarball, not that zip.
