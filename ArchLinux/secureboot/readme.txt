chạy sbat:

https://wiki.archlinux.org/title/GRUB

grub-install --target=x86_64-efi --efi-directory=esp --bootloader-id=BOOT --sbat /usr/share/grub/sbat.csv


check sbat:

objdump -j .sbat -s /path/to/binary.efi


https://wiki.archlinux.org/title/Unified_Extensible_Firmware_Interface/Secure_Boot
2. SET UP shim:
install shim-signed (AUR)


mv BOOTX64.EFI into grubx64.efi
# sudo mv esp/EFI/BOOT/BOOTx64.EFI esp/EFI/BOOT/grubx64.efi

copy shim :
# sudo cp /usr/share/shim-signed/shimx64.efi esp/EFI/BOOT/BOOTx64.EFI
# sudo cp /usr/share/shim-signed/mmx64.efi esp/EFI/BOOT/


Finally, create a new NVRAM entry to boot BOOTx64.EFI:
# efibootmgr --unicode --disk /dev/sdX --part Y --create --label "Shim" --loader /EFI/BOOT/BOOTx64.EFI



3. shim WITH KEY
Install sbsigntools


Create a Machine Owner Key:
$ openssl req -newkey rsa:2048 -nodes -keyout MOK.key -new -x509 -sha256 -days 3650 -subj "/CN=my Machine Owner Key/" -out MOK.crt
$ openssl x509 -outform DER -in MOK.crt -out MOK.cer


Sign your boot loader (named grubx64.efi) and kernel:
# sbsign --key MOK.key --cert MOK.crt --output /boot/vmlinuz-linux /boot/vmlinuz-linux
# sbsign --key MOK.key --cert MOK.crt --output esp/EFI/BOOT/grubx64.efi esp/EFI/BOOT/grubx64.efi


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

4. IMPORT KEY by mokutil
sudo mokutil --import MOK.cer

list key:
# mokutil --list-enrolled




