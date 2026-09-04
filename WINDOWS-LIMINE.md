# Repair Windows booting from Limine

This runbook repairs the current dual-drive setup:

| Device | Purpose | Filesystem |
| --- | --- | --- |
| `/dev/nvme0n1p2` | Windows 11 | NTFS |
| `/dev/nvme1n1p1` | Omarchy and Limine EFI system partition, mounted at `/boot` | FAT32 |

The Windows disk has no EFI system partition. Its first partition is a 16 MB
Microsoft Reserved partition, not an EFI partition. The file at
`C:\Windows\Boot\EFI\bootmgfw.efi` is only a source copy. Chainloading that
file from NTFS does not provide the BCD store and the other files Windows Boot
Manager needs.

There are two repairs in this runbook. The recommended repair creates a
dedicated Windows EFI system partition on the Windows disk. This makes each
disk independently bootable and keeps future Omarchy reinstalls from removing
Windows Boot Manager. The fallback repair puts Windows boot files on Omarchy's
existing EFI partition, which works but must be repeated after formatting the
Omarchy disk.

This follows the approach in the
[Omarchy dual-boot guide](https://github.com/basecamp/omarchy/discussions/1604),
adapted for a machine where Windows has no EFI partition of its own. Microsoft
documents the `bcdboot` options in
[BCDBoot command-line options](https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/bcdboot-command-line-options-techref-di?view=windows-11).

## Before starting

You need:

- A Windows 11 installer or recovery USB booted in UEFI mode.
- Secure Boot disabled while using the current Limine setup.
- A backup of important Windows and Linux files.

The permanent repair resizes the Windows volume and creates one partition.
Back up Windows first. Read each DiskPart selection twice before running a
write command.

## Recommended permanent repair

This is a one-time repair. It creates a 512 MB FAT32 EFI system partition on
`/dev/nvme0n1`, next to Windows. Future Omarchy reinstalls can then erase all
of `/dev/nvme1n1` without removing the Windows bootloader.

### 1. Back up Windows and Limine

Back up important Windows and Linux files first. Then run from Omarchy:

```bash
sudo cp /boot/limine.conf /boot/limine.conf.before-windows
sudo cp /boot/EFI/BOOT/BOOTX64.EFI \
  /boot/EFI/BOOT/BOOTX64.EFI.limine-backup
```

### 2. Open Windows Recovery Command Prompt

1. Boot a Windows 11 installer or recovery USB in UEFI mode.
2. At the first installer screen, press `Shift+F10`.
3. A Windows Command Prompt should open.

### 3. Identify the Windows disk and volume

Start DiskPart:

```text
diskpart
list disk
list volume
```

Identify the roughly 1.8 TB Windows disk and its large NTFS volume by size.
Disk numbers and volume numbers in Windows Recovery may differ from Linux
device names. Do not assume that the Windows disk is `Disk 0`.

Select the large Windows NTFS volume and check how much it can shrink:

```text
select volume <Windows-NTFS-volume-number>
shrink querymax
```

Continue only if DiskPart reports at least 512 MB of available shrink space.

### 4. Make room for the Windows EFI partition

With the Windows NTFS volume still selected, shrink it by 512 MB:

```text
shrink desired=512 minimum=512
```

Select the Windows disk identified in the previous step:

```text
select disk <Windows-disk-number>
list partition
```

Confirm that this disk contains the 16 MB Microsoft Reserved partition, the
large Windows partition, the recovery partition, and 512 MB of unallocated
space.

### 5. Create the dedicated Windows EFI partition

With the Windows disk selected, run:

```text
create partition efi size=512
format quick fs=fat32 label="Windows EFI"
assign letter=S
```

Do not format an existing partition. The `format` command belongs only to the
newly created 512 MB partition.

Assign `W:` to the existing Windows NTFS volume:

```text
list volume
select volume <Windows-NTFS-volume-number>
assign letter=W
exit
```

If `S:` or `W:` is already in use, choose an unused letter and replace it in
the later commands.

### 6. Verify the selected volumes

Run:

```text
dir W:\Windows
dir S:\
```

`W:\Windows` must exist. `S:` should be the new, nearly empty 512 MB FAT32
partition. Stop if either check does not match.

### 7. Install Windows Boot Manager

Run:

```text
bcdboot W:\Windows /s S: /f UEFI /v
```

Expected result:

```text
Boot files successfully created.
```

Confirm that the loader and BCD store exist:

```text
dir S:\EFI\Microsoft\Boot\bootmgfw.efi
dir S:\EFI\Microsoft\Boot\BCD
```

Both files must exist. Restart and boot Omarchy through the firmware's
`Limine` entry.

### 8. Find the new partition in Omarchy

Run:

```bash
lsblk -o NAME,SIZE,FSTYPE,LABEL,PARTUUID,MOUNTPOINTS /dev/nvme0n1
```

Find the 512 MB FAT32 partition labeled `Windows EFI`. Its name will probably
be `/dev/nvme0n1p4`, but use the name shown by `lsblk`.

Mount it and verify the bootloader:

```bash
sudo mkdir -p /mnt/windows-esp
sudo mount /dev/nvme0n1p<partition-number> /mnt/windows-esp
sudo ls -l /mnt/windows-esp/EFI/Microsoft/Boot/bootmgfw.efi
```

Replace `<partition-number>` with the actual number. For example, use `4` for
`/dev/nvme0n1p4`.

### 9. Register Windows Boot Manager in the firmware

Check the existing firmware entries:

```bash
sudo efibootmgr -v
```

If `Windows Boot Manager` already points to the new Windows EFI partition,
skip the creation command. Otherwise run:

```bash
sudo efibootmgr --create \
  --disk /dev/nvme0n1 \
  --part <partition-number> \
  --label "Windows Boot Manager" \
  --loader '\EFI\Microsoft\Boot\bootmgfw.efi'
```

Verify it:

```bash
sudo efibootmgr -v
```

Keep `Limine` first in the firmware boot order. Change the order in firmware
setup if creating the Windows entry moved it ahead of Limine.

### 10. Add Windows to Limine

Use Limine's firmware-entry scanner:

```bash
sudo limine-scan
```

Choose `Windows Boot Manager`. Do not choose `Limine` or `UEFI OS`.

The resulting entry should use Limine's `efi_boot_entry` protocol:

```text
/Windows 11
  protocol: efi_boot_entry
  entry: Windows Boot Manager
```

This tells the firmware to boot Windows from the Windows disk. It does not
copy Windows files onto the Omarchy disk.

Verify the menu:

```bash
sudo limine-list
sudo rg -n -A5 -B2 'Windows' /boot/limine.conf
```

Restart and select Windows:

```bash
sudo reboot
```

### 11. Disable Windows Fast Startup

After Windows starts, open Command Prompt as Administrator and run:

```text
powercfg /h off
```

Then perform a full shutdown:

```text
shutdown /s /t 0
```

### Future Omarchy reinstalls

Once the Windows disk has its own EFI partition:

1. Disconnect or disable the Windows NVMe in firmware if practical.
2. Reinstall Omarchy and format only `/dev/nvme1n1`.
3. Reconnect or re-enable the Windows NVMe.
4. Put `Limine` first in the firmware boot order.
5. Run `sudo limine-scan` and choose `Windows Boot Manager`.

The Windows installer USB, DiskPart, partition resizing, and `bcdboot` are not
needed again. Windows remains bootable from the firmware menu even before it
is added back to Limine.

## Alternative shared-ESP repair

Use the following process only if creating a dedicated Windows EFI partition
is not possible. It stores Windows Boot Manager on Omarchy's EFI partition.
Formatting `/dev/nvme1n1` later will remove it, so the process must be repeated
after an Omarchy reinstall.

## 1. Confirm the disk layout in Omarchy

Run:

```bash
lsblk -o NAME,SIZE,FSTYPE,LABEL,UUID,PARTUUID,MOUNTPOINTS
```

Check that:

- `/dev/nvme0n1p2` is the large Windows NTFS partition.
- `/dev/nvme1n1p1` is FAT32 and mounted at `/boot`.

Stop if those facts have changed. Device names may change after hardware or
firmware changes.

## 2. Back up Limine

Run from Omarchy:

```bash
sudo cp /boot/limine.conf /boot/limine.conf.before-windows
sudo cp /boot/EFI/BOOT/BOOTX64.EFI \
  /boot/EFI/BOOT/BOOTX64.EFI.limine-backup
```

Confirm both backups exist:

```bash
sudo ls -l \
  /boot/limine.conf.before-windows \
  /boot/EFI/BOOT/BOOTX64.EFI.limine-backup
```

## 3. Open Windows Recovery Command Prompt

1. Boot the Windows 11 installer or recovery USB in UEFI mode.
2. At the first installer screen, press `Shift+F10`.
3. A Windows Command Prompt should open.

## 4. Assign temporary drive letters

Start DiskPart:

```text
diskpart
list volume
```

Identify these volumes by filesystem and size, not by their volume numbers:

- The 2 GB FAT32 volume is the Limine EFI system partition.
- The roughly 1.8 TB NTFS volume contains Windows.

Assign `S:` to the FAT32 volume. Replace `<number>` with its actual volume
number:

```text
select volume <2GB-FAT32-volume-number>
assign letter=S
```

Assign `W:` to the large Windows volume:

```text
select volume <Windows-NTFS-volume-number>
assign letter=W
exit
```

If either letter is already in use, choose another unused letter and replace
it in every later command.

## 5. Verify both volumes before writing

Run:

```text
dir S:\EFI\limine
dir W:\Windows
```

The first command must show Limine files. The second must show the Windows
directory. Stop if either command reports that the path does not exist. A
wrong `S:` selection could write boot files to the wrong partition.

## 6. Build the Windows EFI boot environment

Run:

```text
bcdboot W:\Windows /s S: /f UEFI /v
```

Expected result:

```text
Boot files successfully created.
```

Confirm that Windows Boot Manager and its BCD store now exist:

```text
dir S:\EFI\Microsoft\Boot\bootmgfw.efi
dir S:\EFI\Microsoft\Boot\BCD
```

Both files must exist before continuing.

`bcdboot` may replace `S:\EFI\BOOT\BOOTX64.EFI`. That generic fallback path
belongs to Limine in this setup. The next Omarchy steps restore it.

## 7. Return to Omarchy

Restart the computer. If it boots Windows directly, open the firmware boot
menu and choose `Limine`. The existing Limine firmware entry points to
`EFI/limine/limine_x64.efi`, so it should still work even if `bcdboot` changed
the generic fallback loader.

## 8. Restore Limine's fallback loader

Back in Omarchy, redeploy Limine to the fallback path:

```bash
sudo limine-install --fallback
```

Check that the Windows files survived and Limine still exists:

```bash
sudo ls -l \
  /boot/EFI/Microsoft/Boot/bootmgfw.efi \
  /boot/EFI/limine/limine_x64.efi \
  /boot/EFI/BOOT/BOOTX64.EFI
```

## 9. Remove the broken NTFS entry

The previous test entry pointed directly into the Windows NTFS partition.
Remove it:

```bash
sudo limine-entry-tool --remove-entry "Windows" 0
```

It is fine if the command says that no matching entry exists.

## 10. Add the working Windows entry

Point Limine at the Windows Boot Manager now stored on its FAT32 partition:

```bash
sudo limine-entry-tool --add-efi "Windows 11" \
  /boot/EFI/Microsoft/Boot/bootmgfw.efi \
  --priority 30 \
  --overwrite
```

This time the helper receives a real file on FAT32. It should generate an
entry equivalent to:

```text
/Windows 11
  comment: order-priority=30
  protocol: efi_chainload
  image_path: boot():/EFI/Microsoft/Boot/bootmgfw.efi
```

The installed Limine version uses `/boot/limine.conf`. Some older guides call
the file `limine.cfg`; do not create that second file.

## 11. Verify the Limine configuration

Run:

```bash
sudo limine-list
sudo rg -n -A5 -B2 Windows /boot/limine.conf
```

The menu tree must contain `Windows 11`. Its path must reference
`/EFI/Microsoft/Boot/bootmgfw.efi` on `boot():`, not the Windows NTFS UUID.

## 12. Test Windows booting

Restart:

```bash
sudo reboot
```

Select `Windows 11` in Limine. Do not delete the backups until both Omarchy and
Windows have booted successfully.

## 13. Disable Windows Fast Startup

After Windows starts, open Command Prompt as Administrator and run:

```text
powercfg /h off
```

This disables hibernation and Windows Fast Startup. It prevents Windows from
leaving the NTFS volume in a hibernated state when switching to Linux. Also
disable Fast Boot in the computer's firmware if Windows enters recovery only
when launched through Limine.

## Troubleshooting

### `bcdboot` cannot find `W:\Windows`

The Windows volume has a different drive letter in Recovery. Return to
DiskPart, run `list volume`, assign an unused letter to the large NTFS volume,
and verify the directory with `dir <letter>:\Windows`.

### `bcdboot` reports failure while copying boot files

Check that `S:` is the 2 GB FAT32 partition and that it is writable:

```text
dir S:\EFI\limine
```

Do not format it. Formatting that partition removes Limine and the Omarchy
boot files.

### The computer boots Windows without showing Limine

Open the firmware setup and put the `Limine` UEFI entry first in the boot
order. Do not choose `UEFI OS`; that is the generic fallback path and may have
been changed by `bcdboot`.

### Windows appears in Limine but opens Recovery

First disable firmware Fast Boot. If Windows can boot from the firmware menu,
run this from an Administrator Command Prompt in Windows:

```text
powercfg /h off
```

Then perform a full shutdown:

```text
shutdown /s /t 0
```

### Roll back the Limine configuration

From Omarchy:

```bash
sudo cp /boot/limine.conf.before-windows /boot/limine.conf
sudo limine-install --fallback
```

This restores the old menu and redeploys Limine. It does not remove the new
`/boot/EFI/Microsoft` directory.
