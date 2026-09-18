# Permanent Windows and Limine dual-boot repair

This runbook makes the Windows and Omarchy disks independently bootable. It is
tailored to this machine and does not require a recovery USB because Windows
already boots through Limine.

## Current layout

| Device | Current use |
| --- | --- |
| `/dev/nvme0n1p1` | 16 MB Microsoft Reserved partition |
| `/dev/nvme0n1p2` | Windows 11 NTFS partition |
| `/dev/nvme0n1p3` | Windows Recovery partition |
| `/dev/nvme1n1p1` | Omarchy and Limine EFI partition, mounted at `/boot` |
| `/dev/nvme1n1p2` | Encrypted Omarchy installation |

Windows Boot Manager currently lives on `/dev/nvme1n1p1`. Formatting the
Omarchy disk would therefore remove the Windows bootloader. The repair creates
a 512 MB FAT32 EFI System Partition on `/dev/nvme0n1` and installs Windows Boot
Manager there.

Microsoft references:

- [Shrink an NTFS volume](https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/shrink)
- [Create an EFI System Partition](https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/create-partition-efi)
- [BCDBoot command-line options](https://learn.microsoft.com/en-gb/windows-hardware/manufacture/desktop/bcdboot-command-line-options-techref-di?view=windows-11)

## Safety rules

- Back up important Windows and Linux files first.
- Do not assume Windows is Disk 0. Both NVMe drives have the same capacity.
- Identify the Windows disk through volume `C:` before resizing anything.
- Never run `clean`, `delete partition`, or `format` on an existing partition.
- Format only the newly created 512 MB EFI partition.
- Keep the current shared Windows bootloader until the new one passes both
  direct-firmware and Limine boot tests.

## Phase 1: prepare Windows

Boot Windows normally through Limine. Open Terminal or Command Prompt as
Administrator.

### 1. Disable Fast Startup

```text
powercfg /h off
```

### 2. Check BitLocker

```text
manage-bde -status C:
```

If BitLocker protection is enabled, save the recovery key and suspend
protection:

```text
manage-bde -protectors -disable C:
```

Leave it suspended until all boot tests pass.

## Phase 2: create the dedicated Windows ESP

### 3. Identify the disk containing Windows

Start DiskPart:

```text
diskpart
list volume
select volume C
detail volume
```

Write down the disk number reported by `detail volume`. This is the Windows
disk. Do not choose a disk based only on its size.

Check the available shrink space:

```text
shrink querymax
```

Continue only if DiskPart reports at least 512 MB. If it reports less, stop.

### 4. Shrink the Windows volume

With volume `C:` still selected:

```text
shrink desired=512 minimum=512
```

Select the Windows disk using the number from `detail volume`:

```text
select disk <Windows-disk-number>
detail disk
list partition
```

Before continuing, confirm that this disk contains:

- The 16 MB Microsoft Reserved partition
- The large Windows partition
- The roughly 748 MB Recovery partition
- About 512 MB of unallocated space

### 5. Create and format the new ESP

With the Windows disk selected:

```text
create partition efi size=512
format quick fs=fat32 label="Windows EFI"
assign letter=S
```

Verify the new partition:

```text
list partition
list volume
```

You should see a new 512 MB FAT32 volume named `Windows EFI`.

## Phase 3: install Windows Boot Manager

### 6. Build the EFI boot environment

Exit DiskPart:

```text
exit
```

Install Windows Boot Manager and its BCD store:

```text
bcdboot C:\Windows /s S: /f UEFI /v
```

Expected output:

```text
Boot files successfully created.
```

Verify both files:

```text
dir S:\EFI\Microsoft\Boot\bootmgfw.efi
dir S:\EFI\Microsoft\Boot\BCD
```

Both must exist.

### 7. Remove the temporary drive letter

```text
diskpart
select volume S
remove letter=S
attributes volume set GPT_ATTRIBUTE_PLATFORM_REQUIRED
exit
```

Restart and choose `Limine` or `UEFI OS` from the firmware boot menu to return
to Omarchy.

## Phase 4: register and test the new ESP

### 8. Find the new partition in Omarchy

```bash
lsblk -o NAME,PATH,SIZE,FSTYPE,LABEL,PARTUUID,PARTTYPE,MOUNTPOINTS \
  /dev/nvme0n1
```

Find the 512 MB FAT32 partition labeled `Windows EFI`. It will probably be
`/dev/nvme0n1p4`, but use the partition number shown by `lsblk`.

In the commands below, replace `<N>` with that number.

Mount and verify the partition:

```bash
sudo mkdir -p /mnt/windows-esp
sudo mount /dev/nvme0n1p<N> /mnt/windows-esp

sudo ls -l \
  /mnt/windows-esp/EFI/Microsoft/Boot/bootmgfw.efi \
  /mnt/windows-esp/EFI/Microsoft/Boot/BCD
```

### 9. Create a temporary firmware entry

Create a test entry without changing the permanent boot order:

```bash
sudo efibootmgr --create-only \
  --disk /dev/nvme0n1 \
  --part <N> \
  --label "Windows Boot Manager Test" \
  --loader '\EFI\Microsoft\Boot\bootmgfw.efi'
```

Inspect it:

```bash
sudo efibootmgr -v
```

Write down the new `BootXXXX` number. Confirm that it points to the new Windows
ESP. It must not point to Omarchy's ESP UUID:

```text
2a35760e-cee2-45bb-b593-7b5fa83cdd8a
```

### 10. Test the new entry directly

Replace `XXXX` with the test entry number:

```bash
sudo efibootmgr --bootnext XXXX
sudo reboot
```

Windows should boot directly. If it fails, use the firmware menu to return to
Limine. Do not remove the old working entry.

## Phase 5: replace the old firmware entry

After the direct Windows test succeeds, restart and select Limine from the
firmware menu.

### 11. Identify both Windows entries

```bash
sudo efibootmgr -v
```

Identify:

- The old `Windows Boot Manager`, which points to Omarchy ESP UUID
  `2a35760e-cee2-45bb-b593-7b5fa83cdd8a`
- `Windows Boot Manager Test`, which points to the new ESP on `/dev/nvme0n1`

Write down both boot numbers. Do not rely on the old numbers from an earlier
session.

### 12. Remove the old firmware entry

Delete only the entry pointing to the Omarchy ESP:

```bash
sudo efibootmgr --bootnum <OLD> --delete-bootnum
```

### 13. Create the final firmware entry

```bash
sudo efibootmgr --create-only \
  --disk /dev/nvme0n1 \
  --part <N> \
  --label "Windows Boot Manager" \
  --loader '\EFI\Microsoft\Boot\bootmgfw.efi'
```

Inspect the entries and write down the new final boot number:

```bash
sudo efibootmgr -v
```

Delete the temporary test entry:

```bash
sudo efibootmgr --bootnum <TEST> --delete-bootnum
```

### 14. Set the firmware boot order

Use the boot IDs shown by `efibootmgr`. Set the order to:

1. Limine
2. The new Windows Boot Manager
3. UEFI OS

For example, if Limine is `0001`, the new Windows entry is `0002`, and UEFI OS
is `0008`:

```bash
sudo efibootmgr --bootorder 0001,0002,0008
```

That command is only an example. Use the IDs currently shown on your machine.

## Phase 6: switch Limine to the firmware entry

### 15. Remove the old Limine menu entries

Inspect the menu:

```bash
sudo limine-list
```

Remove the previous Windows entries:

```bash
sudo limine-entry-tool --remove-entry "Windows" 0
sudo limine-entry-tool --remove-entry "Windows 11" 0
```

It is fine if one command reports that no matching entry exists.

### 16. Add the new firmware entry

```bash
sudo limine-scan
```

Choose `Windows Boot Manager`. Confirm that the displayed GPT UUID belongs to
the new Windows ESP on `/dev/nvme0n1`.

Do not choose `Windows Boot Manager Test`, `Limine`, or `UEFI OS`.

### 17. Verify Limine

```bash
sudo limine-list

sudo rg -n -A7 -B3 -i \
  'windows|efi_boot_entry|bootmgfw' \
  /boot/limine.conf
```

The Windows entry should use the firmware protocol:

```text
/Windows Boot Manager
  protocol: efi_boot_entry
  entry: Windows Boot Manager
```

It should not point to this path:

```text
boot():/EFI/Microsoft/Boot/bootmgfw.efi
```

That path belongs to Omarchy's ESP.

## Phase 7: prove the disks are independent

### 18. Disable the old shared copy without deleting it

Rename the Microsoft directory on Omarchy's ESP:

```bash
sudo mv /boot/EFI/Microsoft \
  /boot/EFI/Microsoft.shared-esp-backup
```

Restart and select Windows in Limine:

```bash
sudo reboot
```

If Windows boots, it is using its own ESP. If it fails, return to Omarchy and
restore the shared copy:

```bash
sudo mv /boot/EFI/Microsoft.shared-esp-backup \
  /boot/EFI/Microsoft
```

### 19. Finish cleanup

After several successful Windows and Omarchy boots:

```bash
sudo umount /mnt/windows-esp
```

Keep `/boot/EFI/Microsoft.shared-esp-backup` for a few days before deleting it.

If BitLocker was suspended, re-enable it from an Administrator Command Prompt
in Windows:

```text
manage-bde -protectors -enable C:
```

## Final verification

From Omarchy:

```bash
lsblk -o NAME,SIZE,FSTYPE,LABEL,PARTUUID,PARTTYPE,MOUNTPOINTS
sudo efibootmgr -v
sudo limine-list
```

The final state should be:

- `/dev/nvme0n1` has a 512 MB FAT32 partition labeled `Windows EFI`.
- `Windows Boot Manager` points to that partition.
- `Limine` remains first in the firmware boot order.
- The Limine Windows entry uses `efi_boot_entry`.
- Windows boots while `/boot/EFI/Microsoft` is absent or renamed.

At that point, formatting `/dev/nvme1n1` during a future Omarchy reinstall will
not remove Windows Boot Manager.
