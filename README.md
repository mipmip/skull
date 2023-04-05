# Skull

**Skull** helps developers with multiple computers and hundreds of projects,
cloning their repo's at the correct location using a central catalog-file.

## Why

Besides DRY, having a predefined directory layout for all your code-projects,
allows you to do more automation. I wrote skull after I start using
[gs-git](https://github.com/mipmip/gs-git), a git monitor which checks for
dirty git repo's.

## Installation

You need crystal to build skull.

```
clone https://github.com/mipmip/skull
cd skull
shards
make
./bin/skull
```

## Configuration

Create a skull catalog file at `~/.config/skulls.yaml`.

Populate with repo-groups and repo's:

```yaml
home:
  base_dir: ~/
  repos:
    - source: mipmip/secondbrain
    - source: mipmip/nixos

forks:
  base_dir: ~/cForks
  repos:
    - source: mipmip/hugoDocs
    - source: mipmip/hugo
    - source: mipmip/nixpkgs
    - source: mipmip/NUR
    - source: mipmip/nur-search
    - source: mipmip/octokit.cr
    - source: mipmip/sc-im
    - source: mipmip/smug
    - source: mipmip/nixos-homepage
```

## Usage

```
skull help
skull [subcommand] help
```

## Development

Use crystal, if you have nix and flakes you can run

```
nix develop
shards
make
./bin/skull -c test/skull.yaml
```

## Contributing

1. Fork it (<https://github.com/mipmip/skull/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Pim Snel](https://github.com/mipmip) - creator and maintainer
