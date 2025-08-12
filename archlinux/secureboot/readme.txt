https://wiki.archlinux.org/title/GRUB
https://wiki.archlinux.org/title/Unified_Extensible_Firmware_Interface/Secure_Boot

package need to be installed: shim-signed, sbsigntools, moktuil, efibootmgr

GRUB INSTALLATION WITH MODULES
To install GRUB with the required modules, use the following configuration:
    $ GRUB_MODULES="ext2 fat part_gpt part_msdos linux search search_fs_uuid search_fs_file search_label normal efinet all_video boot btrfs cat chain configfile echo efifwsetup efinet ext2 fat font gettext gfxmenu gfxterm gfxterm_background gzio halt help hfsplus iso9660 jpeg keystatus loadenv loopback linux ls lsefi lsefimmap lsefisystab lssal memdisk minicmd normal ntfs part_apple part_msdos part_gpt password_pbkdf2 png probe reboot regexp search search_fs_uuid search_fs_file search_label serial sleep smbios squash4 test tpm true video xfs zfs zfscrypt zfsinfo cpuid play cryptodisk gcry_arcfour gcry_blowfish gcry_camellia gcry_cast5 gcry_crc gcry_des gcry_dsa gcry_idea gcry_md4 gcry_md5 gcry_rfc2268 gcry_rijndael gcry_rmd160 gcry_rsa gcry_seed gcry_serpent gcry_sha1 gcry_sha256 gcry_sha512 gcry_tiger gcry_twofish gcry_whirlpool luks lvm mdraid09 mdraid1x raid5rec raid6rec http tftp"
    $ sudo grub-install --target=x86_64-efi --efi-directory=/boot/efi/ --modules="$GRUB_MODULES" --sbat /usr/share/grub/sbat.csv
check sbat:
    objdump -j .sbat -s /path/to/binary.efi
Copy shim and MokManager to your boot loader directory on ESP; use previous filename of your boot loader as as the filename for shimx64.efi
    $ cp /usr/share/shim-signed/shimx64.efi esp/EFI/BOOT/BOOTx64.EFI
    $ cp /usr/share/shim-signed/mmx64.efi esp/EFI/BOOT/

MISTAKE IN EFI BOOT ENTRY CREATION
When setting up the EFI boot entry, I made the mistake of specifying the wrong loader directory. The incorrect command:
    $ sudo efibootmgr --unicode --disk /dev/sda --part 1 --create --label "Arch-shim" --loader /boot/efi/EFI/BOOT/BOOTX64.EFI
The correct command should have been:
    $ sudo efibootmgr --unicode --disk /dev/sda --part 1 --create --label "Arch-shim" --loader /EFI/BOOT/BOOTX64.EFI

SHIM WITH KEY
    $ openssl req -newkey rsa:2048 -nodes -keyout MOK.key -new -x509 -sha256 -days 3650 -subj "/CN=my Machine Owner Key/" -out MOK.crt
    $ openssl x509 -outform DER -in MOK.crt -out MOK.cer

Sign your boot loader (named grubx64.efi) and kernel:
    $ sbsign --key MOK.key --cert MOK.crt --output /boot/vmlinuz-linux /boot/vmlinuz-linux
    $ sbsign --key MOK.key --cert MOK.crt --output esp/EFI/BOOT/grubx64.efi esp/EFI/BOOT/grubx64.efi

Import chứng chỉ vào MOK list:
    $ sudo mokutil --import MOK.crt

Kiểm tra key đã import chưa:
    $ sudo moktuil --list-enrolled

You will need to do this each time they are updated. You can automate the kernel signing with a mkinitcpio post hook. Create the following file and make it executable:
/etc/initcpio/post/kernel-sbsign
    #!/usr/bin/env bash

    kernel="$1"
    [[ -n "$kernel" ]] || exit 0

    # use already installed kernel if it exists
    [[ ! -f "$KERNELDESTINATION" ]] || kernel="$KERNELDESTINATION"

    keypairs=(/path/to/MOK.key /path/to/MOK.crt)

    for (( i=0; i<${#keypairs[@]}; i+=2 )); do
        key="${keypairs[$i]}" cert="${keypairs[(( i + 1 ))]}"
        if ! sbverify --cert "$cert" "$kernel" &>/dev/null; then
            sbsign --key "$key" --cert "$cert" --output "$kernel" "$kernel"
        fi
    done
