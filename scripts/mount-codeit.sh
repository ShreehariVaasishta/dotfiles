#!/bin/bash
# Script to set up the codeit partition mount point without formatting
# Usage: sudo ./mount-codeit.sh <mount_point>
# Example: sudo ./mount-codeit.sh /home/sln/work

set -e

# Check if running as root
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root (use sudo)"
    exit 1
fi

# Get the mount point from arguments or use default
MOUNT_POINT="${1:-/home/sln/codeit}"
CODEIT_UUID="3f19ff93-29ec-45a2-8981-ee231ce96999"
USERNAME=$(logname || echo $SUDO_USER || echo $USER)
GROUP=$(id -gn $USERNAME)

echo "Setting up codeit partition (UUID: $CODEIT_UUID) to mount at $MOUNT_POINT"
echo "User ownership will be set to: $USERNAME:$GROUP"

# Create the mount point if it doesn't exist
if [ ! -d "$MOUNT_POINT" ]; then
    echo "Creating mount point directory: $MOUNT_POINT"
    mkdir -p "$MOUNT_POINT"
fi

# Check if partition is already in fstab
if grep -q "$CODEIT_UUID" /etc/fstab; then
    echo "Partition already exists in fstab. Updating..."
    # Remove existing entry
    sed -i "/$CODEIT_UUID/d" /etc/fstab
fi

# Add entry to fstab
echo "Adding mount entry to /etc/fstab"
echo "UUID=$CODEIT_UUID $MOUNT_POINT btrfs defaults,compress=zstd 0 2" >> /etc/fstab

# Check if partition is already mounted
if mount | grep -q "$MOUNT_POINT"; then
    echo "Unmounting existing mount at $MOUNT_POINT"
    umount "$MOUNT_POINT"
fi

# Mount the partition
echo "Mounting partition"
mount -a || { echo "Mount failed. Check if the partition exists and is not in use."; exit 1; }

# Set ownership
echo "Setting ownership of $MOUNT_POINT to $USERNAME:$GROUP"
chown -R "$USERNAME:$GROUP" "$MOUNT_POINT"
chmod -R 755 "$MOUNT_POINT"

echo "Done! Codeit partition is now mounted at $MOUNT_POINT"
echo "You can access your files at $MOUNT_POINT"
echo ""
echo "To verify the mount, run: df -h | grep codeit"
df -h | grep codeit

exit 0
