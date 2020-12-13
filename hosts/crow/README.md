# crow (laptop)
This is the configuration for my laptop, a ThinkPad L420.
It has a 240 GiB SSD drive and 8 GiB of RAM.

## Disk partitioning layout
```
/dev/sda1 -> /boot  [512 MiB]
/dev/sda2 -> (swap) [8 GiB]
/dev/sda3 -> tank   [rest of the drive, encrypted]
```

## ZFS partition structure
```
tank
|- ephemeral
|  |- home
|  \- root
|- nix
\- persist
```

## (rough) Installation procedure
- Wipe drive (preferably by overwriting with random data)
- Partition according to defined layout
- Create ZFS pool and datasets accordingly
- Mount partitions
- Install NixOS

There's a script (`install.sh`) that automates this procedure allowing
an almost unattended installation, but it hasn't been tested thoroughly,
so be careful if you choose to use it, I've used it myself, but can't
ensure it will work for you.
