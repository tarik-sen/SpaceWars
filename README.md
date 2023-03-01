# SpaceWars
16 bit real-mode assembly rendition of classic space game.

<img src=docs/demo.gif width=500px>

## Installation
### Requirements:
  - GNU Compiler Collection (gcc) 

Check the prerequisite by:
```bash
apt-cache policy gcc
```
Install if not already:
```bash
sudo apt-get install gcc
```
### Source
```bash
git clone 'https://github.com/tarik/SpaceWars'
cd SpaceWars
```

### Commands to run
Create object files
```bash
as genericBootloader.s -o genericBootloader.o
as SpaceWars.s -o SpaceWars.o
```

Link phase
```bash
ld genericBootloader.o -o genericBootloader.bin --oformat binary -Ttext 0x7c00 -e _start
ld SpaceWars.o -o SpaceWars.bin --oformat binary -Ttext 0x9000 -e _KernelStart
```

You can either test it on qemu or on your own hardware.
#### 1) QEMU
Burn anywhere you want and test with qemu.
> ⚠️ If QEMU is not installed, run "sudo apt install qemu-kvm".

```bash
dd if=genericBootloader.bin of=kernel_test bs=512 status=progress
dd if=SpaceWars.bin of=kernel_test bs=512 status=progress seek=1

qemu-system-x86_64 kernel_test
```

#### 2) Bare metal
Burn into your usb. Start the computer from your usb to test it.
```bash
dd if=genericBootloader.bin of=/dev/sda bs=512 status=progress
dd if=SpaceWars.bin of=/dev/sda bs=512 status=progress seek=1
```

