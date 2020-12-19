echo 'Verify if the system clock is accurate by typing timdatectl set-ntp true'
timdatectl set-ntp true

echo 'Partition the disk'
fdisk /dev/sda
echo 'Make the file systems'
mkfs.fat -F32 /dev/sda1
mkswap /dev/sda2
swapon /dev/sda2
mkfs.ext4 /dev/sda3
mount /dev/sda3 /mnt
echo 'Installung base system'
pacstrap /mnt base linux linux-firmware
echo 'Others'
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt

echo 'Generating the file system tab'
genfstab -U /mnt >> /mnt/etc/fstab
echo 'Going to our new root partition'
arch-chroot /mnt
echo 'Setting the time zone'
ln -sf /usr/share/zoneinfo/Romania/Bucharest /etc/localtime # ln = link
echo 'A new file will be created in /etc/adjtime'
hwclock --systohc

#############################################################################
ln -sf /usr/share/zoneinfo/Europe/Bucharest /etc/localtime
hwclock --systohc
echo en_US.UTF8 UTF8 >> /etc/local.gen
locale-gen
echo 'ARCH-3POINT1415' >> /etc/hostname
echo '127.0.0.1	localhost' >> /etc/hosts
echo '::1		localhost' >> /etc/hosts
echo '127.0.1.1	ARCH-3POINT1415.localdomain ARCH-3POINT1415' >> /etc/hosts
pacman -S grub efibootmgr dosfstools os-prober mtools
mkdir /boot/EFI
mount /dev/sda1 /boot/EFI
grub-install --target=x86_64-efi --bootloader-id=grub_uefi ==recheck
grub-mkconfig -o /boot/grub/grub.cfg
pacman -S networkmanager nvim git
systemctl enable NetworkManager

exit
#############################################################################

umount -l /mnt