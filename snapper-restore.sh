#!/bin/bash

case $1 in
	"help") 
		echo "./snapper-restore.sh [help/restore/clean]

		[help]
		./snapper-restore.sh help
		Show Help Screen

		[restore]
		./snapper-restore.sh restore [block-device] [subvolume-name] [snapshot-number]
		Rollback a snapper snapshot

			[arguments]
			block-device: The block device with the btrfs filesystem, this will be mounted with the '/' subvol for restoration.
			subvolume-name: The name of the subvolume to be restored.
			snapshot-number: The snapshot number to be restored. List all snapshots using 'snapper -c [config] list'.
		
		[clean]
		./snapper-restore.sh clean [block-device] [subvolume-name]
		Clean the backup snapshot of [subvolume-name] created during restoration.
		CAUTION: SHOULD BE DONE AFTER A CLEAN REBOOT AFTER RESTORATION

			[arguments]
			block-device: The block device with the btrfs filesystem, this will be mounted with the '/' subvol for restoration.
			subvolume-name: The name of the subvolume which was restored.
		"
	;;
	"restore")
		set -e
		echo "Mounting $2 with subvol=/ at /mnt"
		mount -t btrfs -o subvol=/ $2 /mnt

		echo "Moving $3 to $3-backup"
		cd /mnt
		mv $3 $3-backup

		echo "Creating a snapshot of $3-backup /.snapshots/$4/snapshot at $3"
		btrfs subvolume snapshot $3-backup/.snapshots/$4/snapshot $3
		echo "Successfully created the snapshot"
		
		echo "Moving the .snapshots directory from $3-backup/ back to $3/"
		mv $3-backup/.snapshots $3/

		echo "Unmounting /mnt"
		umount /mnt
	;;
	"clean")
		echo "Have you rebooted successfully after mounting snapshot?(y/n)"
		read choice
		case $choice in
			"y") ;;
			"n") exit ;;
			*)
				echo "Enter y/n exactly."
				exit ;;
		esac

		set -e
		echo "Mounting $2 with subvol=/ at /mnt"
		mount -t btrfs -o subvol=/ $2 /mnt

		echo "Deleting subvolume $3-backup"
		btrfs subvolume delete $3-backup
		echo "Successfully deleted subvolume $3-backup"

		echo "Unmounting /mnt"
		umount /mnt

		echo "Successfully cleaned $3-backup"
	;;
	*) echo "No valid command invoked. Use help argument to view the help screen" ;;
esac