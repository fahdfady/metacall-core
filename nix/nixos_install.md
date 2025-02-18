# MetaCall NixOS Installation Guide

## Prerequisites
- NixOS 23.11 or newer
- Flakes enabled (see [Flakes Setup](https://nixos.wiki/wiki/Flakes))

## Installation Methods

### Method 1: Via Flake (Recommended)

1. **Add to system configuration**:
```nix
# configuration.nix
{ inputs, ... }: {
  imports = [ inputs.metacall.nixosModules.default ];
  services.metacall = {
    enable = true;
    port = 8080; # Optional
  };
}
```

2. **Update inputs**:
```nix
# flake.nix
inputs.metacall.url = "github:metacall/core";
```

3. **Build & Activate**:
```bash
sudo nixos-rebuild switch --flake .#your-hostname
```

### Method 2: Temporary Installation
```bash
nix run github:metacall/core
```

## Development Environment
```bash
nix develop github:metacall/core
# Inside shell:
mkdir -p build && cd build
cmake .. && make -j$(nproc)
```

## Troubleshooting

### Hash Mismatch
1. Build with temporary hash:
```bash
nix build --impure .#metacall
```
2. Update `metacall.nix` with the actual hash from error message.

### Missing Dependencies
Add required packages to `nativeBuildInputs` in `nix/packages/metacall.nix`:
```nix
# Example additional dependencies
swig
jdk
ruby
```

### Service Not Starting
Check logs:
```bash
journalctl -u metacall.service -f
```

## Uninstallation
1. Remove service from configuration
2. Garbage collect:
```bash
sudo nix-collect-garbage -d
```

## Contributing
To update the Nix integration:
1. Update `nix/` directory
2. Test with:
```bash
nix flake check
```
3. Submit PR with updated documentation
Final Steps

    Add these files to the repository:

Copy

nix/
├── modules/
│   └── default.nix
└── packages/
    └── metacall.nix
flake.nix
docs/NIXOS_INSTALL.md

    Update README.md with a NixOS section linking to the installation guide.

    Submit PR to MetaCall core repository with:

    Flake infrastructure

    NixOS module

    Documentation

    CI integration (if applicable)