# Snapper Restore Script
Snapper Restore script is a super simple bash script which restores or rollbacks a snapper snapshot for any subvolume for the btrfs filesystem. It's simple and easy to use and comes with a help screen for the user's convenience. It restores the snapshot while not removing any other snapshots (including the one restored) from the btrfs root. The script follows the Arch Wiki Guide to restore snapper snapshots, and can be found [here](https://wiki.archlinux.org/title/snapper#Restore_snapshot).

## Usage
To use the script, follow these steps
1. Get the block device where the btrfs filesystem is mounted. The following command lists all the block devices.
   
   `lsblk -f`

3. Get the subvolume name which you want to restore. List the subvolumes using the following command.

   `btrfs subvolume list [path]`
4. Get the snapshot number to restore. Get the snapshots numbers using the following command for a specified config.

   `snapper -c [config] list`

5. Then run the script using these arguments (make sure that /mnt directory is unmounted):

   `./snapper-restore.sh restore [block-device] [subvolume-name] [snapshot-number]`

6. If the snapshot is successfully restored then reboot your system and after a clean boot, run the script again using these arguments:

   `./snapper-restore.sh clean [block-device] [subvolume-name]`

   This cleans up the backup subvolume created during the restoration process.
   
