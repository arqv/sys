#!/bin/sh

# XXX: This script will zero out the entire drive (unless the NO_WIPE
#      variable is set), and regenerate the filesystems of the drive.

# The script will default to the '/dev/sda' drive unless it's passed
# an argument, and it assumes that the current working directory is the
# repository root.
# Run as root.

DISK=${1:-/dev/sda}
USERS=$(nix eval -f ../../profiles/core/users/get_users.nix --raw)

if [[ ! "$NO_WIPE" =~ ^[yY]$ ]]; then
	echo ":: wiping drive '$DISK'"
	dd if=/dev/urandom of=$DISK status=progress
fi

echo ":: partitioning disk"
sfdisk $DISK <<EOF
label: dos

start=2048,size=1048576,type=83
size=8388608,type=82
type=83
EOF
echo ":: creating filesystems"
echo "   -> ${DISK}1 :: boot"
mkfs.ext4 "${DISK}1"
echo "   -> ${DISK}2 :: swap"
mkswap "${DISK}2"
echo "   -> ${DISK}3 :: root (you'll be prompted with a password prompt)"
zpool create -O mountpoint=none -O atime=off -o ashift=12 \
	-O acltype=posixacl -O xattr=sa -O compression=on \
	-O encryption=aes-256-gcm -O keyformat=passphrase \
	tank "${DISK}3"
echo ":: creating root filesystems"
echo "   -> ephemeral/"
zfs create -o mountpoint=legacy tank/ephemeral
echo "   -> ephemeral/root"
zfs create -o mountpoint=legacy tank/ephemeral/root
zfs snapshot tank/ephemeral/root@blank
echo "   -> ephemeral/home"
zfs create -o mountpoint=legacy tank/ephemeral/home
for user in $USERS; do
	mkdir "/mnt/${user}"
done
echo "   -> nix"
zfs create -o mountpoint=legacy tank/nix
echo "   -> persist"
zfs create -o mountpoint=legacy tank/persist
echo ":: mounting filesystems"
echo "   -> root dataset"
mkdir /mnt
mount -t zfs tank/ephemeral/root /mnt
echo "   -> home dataset"
mkdir /mnt/home
mount -t zfs tank/ephemeral/home /mnt/home
echo "   -> nix dataset"
mkdir /mnt/nix
mount -t zfs tank/nix /mnt/nix
echo "   -> persistent dataset"
mkdir /mnt/persist
mount -t zfs tank/persist /mnt/persist
echo "   -> boot partition"
mkdir /mnt/boot
mount "${DISK}1" /mnt/boot
echo "   -> swap partition"
swapon "${DISK}2"
echo ":: installing NixOS"
nixos-install --flake ".#crow" --no-root-passwd --impure
echo ":: fixing user partition permissions"
for user in $USERS; do
	nixos-enter --root /mnt -c "chown -R ${user}:users /home/${user}"
done
zfs snapshot tank/ephemeral/home@blank
echo ":: done"
