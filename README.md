# Quartz

An i386 hobby kernel in the shape of Mac OS 9. It boots into a plain 80x25 VGA
**text** console and nothing else: no framebuffer, no pixels, no BMPs. The idea
is to grow the kernel in a medium that cannot corrupt itself, and to bring the
graphical layer back once there is something worth drawing.

```
+----------------------------------------------------------+
|  Quartz 0.2.0 - a text mode kernel                        |
|  built Oct  4 2026 14:17:13                              |
|                                                          |
|  [boot] multiboot flags 0x00001a6f                        |
|  [boot] 130559 KB reported, 127 MB usable, 6 map entries  |
|  [boot] 12 module(s) on disk                              |
|  [boot] IDT loaded, PIC remapped, IRQ0 and IRQ1 unmasked |
|  [boot] timer armed at 100 Hz, keyboard live             |
|                                                          |
|    Open Firmware 1.0  (Quartz)                            |
|    hold o then f to enter the firmware                    |
|  [boot] handing over to the shell                         |
|                                                          |
|  Quartz 0.2.0 - text mode shell. Type 'help'.             |
|                                                          |
|  Quartz>                                                 |
+----------------------------------------------------------+
```

## Dependencies

Everything builds inside **WSL** (Windows Subsystem for Linux). The Windows side
only needs `build.bat` / `run.bat`, which are thin wrappers around `make`.

Enable WSL once, from an **Administrator** PowerShell or cmd prompt:

```powershell
wsl --install -d Ubuntu
```

Reboot Windows, launch Ubuntu once so it finishes setting up, then install the
toolchain:

```bash
sudo apt update
sudo apt install -y build-essential gcc-i686-linux-gnu binutils-i686-linux-gnu nasm grub-pc-bin xorriso mtools qemu-system-x86
```

| Package | Why Quartz needs it |
| --- | --- |
| `gcc-i686-linux-gnu` | provides `/usr/bin/i686-linux-gnu-gcc`, which the Makefile invokes by name. **Not** `gcc-multilib`: that one only teaches the native `gcc` about `-m32` and does not install the cross compiler the build actually calls |
| `binutils-i686-linux-gnu` | provides `/usr/bin/i686-linux-gnu-ld`, the linker half of the same toolchain |
| `nasm` | assembles `src/boot/boot.asm` and `src/boot/isr.asm` |
| `grub-pc-bin` | `grub-mkrescue` |
| `xorriso` | `grub-mkrescue` refuses to build an ISO without it |
| `mtools` | GRUB reads `disk/` while assembling the ISO |
| `qemu-system-x86` | running the result from WSL |
| `build-essential` | `make`, and the shell the `services` target uses |

On Windows, `build.bat` and `run.bat` want **QEMU for Windows** on `PATH` (the
WSL build works without it, `make run` uses the Linux QEMU instead).

If `i686-linux-gnu-gcc` is missing, `make` stops at the top with the install
command instead of failing later with `Error 127`. To check the machine at any
time:

```bash
make deps
```

It lists every tool above, prints `[ok]` or `[MISSING]` for each, and echoes the
include path that `-isystem` resolves to.

## Building and running

From Windows:

```bat
build.bat      rem checks WSL, reports missing packages, builds the ISO, boots QEMU
run.bat        rem boots the ISO that is already built
```

Or straight from WSL:

```bash
make iso       rem build/quartz.iso
make run       rem boot it under QEMU with the serial log attached
make clean
```

QEMU is launched with `-serial stdio`. The console is the VGA text mode, so the
interesting output is on the QEMU window; the terminal gets the same text
through COM1, which is how you debug a kernel whose screen will not come up.

## Using the shell

| Command | What it does |
| --- | --- |
| `help` | list the commands |
| `clear` | wipe the screen |
| `echo <text>` | print the arguments |
| `color [fg [bg]]` | set the text attribute, `color` alone lists the names |
| `serial [on\|off]` | toggle the COM1 mirror |
| `version` | version, build stamp, console size |
| `uptime` | ticks and elapsed time |
| `date` | time from the CMOS RTC |
| `mem` | the memory map GRUB handed over |
| `ls [filter]` | list the modules on disk |
| `cat <file>` | hex dump a module |
| `threads` | scheduler state |
| `services` | registered services |
| `start <name>` | find `<name>.service` on the disk and launch it |
| `run` / `stop` / `call` | drive the service manager by path |
| `crash [code]` | panic on purpose, to see the panic screen |
| `reboot` | pulse the 8042 reset line |

Arrow keys walk the history, Ctrl-C abandons the current line.

## PrismT

TU is Text-UI: a small windowed interface over the text console, the way Windows
1.0 was an interface over MS-DOS, with no framebuffer involved.

The interface lives in `src/kernel/prismtu.c`, **linked into the kernel** rather
than into a service, so the shell, a command and the service all draw boxes
through the same code. `prismtu_box_rule` / `_open` / `_close` / `_line` are the
primitives; `prismtu_menubar`, `prismtu_splash` and `prismtu_about` are
compositions of them.

`services/prismtu/prismtu.c` is left with only the service boilerplate:
registration, `Init`/`Shutdown`, and a function table so `call` can reach the
drawing entry points. Anything graphical about PrismT gets built in the kernel
module, not duplicated per service.

`start prismtu` finds `prismtu.service` anywhere on the disk and launches it:

```
Quartz> start prismtu
start: PrismT, at /system/compiled/prismtu/prismtu.service
[prismtu] Init
  File  Edit  View  Special                                   PrismT | 07:47 PM
```

The search is by file name across the whole disk: the module list is flat, so
`fs_find_basename()` compares the last path component of every name rather than
walking a tree. A `.service` file that is on the disk but not registered in the
kernel is reported as exactly that, which is what `start prism` says today, since
the graphical Prism is shipped but not built.

The original graphical Prism is untouched, on both sides: `services/prism/` and
its `disk/system/compiled/prism/prism.service` copy are still written onto the
boot disk by `make`, it just cannot be linked into a kernel that has no
framebuffer.

## Layout

```
src/boot/boot.asm    multiboot header, requests text mode
src/boot/isr.asm     exception stubs, IRQ0/IRQ1, the thread context switch
src/kernel/
  quartz.c           boot order
  console.[ch]       VGA text console, printf, COM1 mirror
  interrupt.[ch]     IDT + 8259 PIC, exception names
  timer.[ch]         PIT at 100 Hz, sleep, uptime
  keyboard.[ch]      scancode set 1, event queue, modifiers, auto-repeat
  io.h               outb/inb, previously copy-pasted into every driver
  multiboot.h        GRUB's handover structs
  mem.[ch]           memory map
  rtc.[ch]           CMOS real time clock
  fs.[ch]            GRUB modules as a flat file list
  shell.[ch]         line editor, history, command table
  openfirmware.[ch]  the crash screen and the firmware screen, in text
  prismtu.[ch]       PrismT, the text user interface: boxes, menubar, splash
  service.[ch]       service registry, kept from the Prism era
  thread.[ch]        round robin scheduler with hand built stacks
  prism.[ch]         parked: the graphical menubar, see below
  font.h             CP437 8x16 bitmap font, unused until the framebuffer returns
services/prism/      the graphical Prism, on the boot disk, not linked
services/prismtu/    the service wrapper; the UI itself is in src/kernel/prismtu.c
disk/                the install disk: bitmaps plus the .service copies
```

`services/*/manifest.txt` decides where a service's source is mirrored inside
the ISO, and `make` copies it there and generates `build/grub.cfg` with one GRUB
`module` line per file. Services are linked **into the kernel**; the copy on the
ISO is the manifest of record, which is why `run`, `stop` and `call` address
services by their `/system/compiled/...` path.

## Two things GRUB does not tell you plainly

Both of these cost an afternoon the first time round, so they are written down
here and in the source:

- **Bit 3 of the multiboot flags must stay clear.** It is only meaningful in
  multiboot2. Set it and GRUB 2.x rejects the whole header with
  `error: unsupported flag: 0xf`. Modules need no flag: GRUB passes whatever the
  `module` lines declare.
- **The memory map entries are 24 bytes, not 20.** GRUB lays them out as
  `size, addr(8), len(8), type` and leaves `size` holding 20, the size of the
  shape the spec describes. Walking the list by `entry.size` walks into the
  middle of the second entry. Use `sizeof()` as the stride.

## When the framebuffer comes back

`src/kernel/font.h` and the parked `src/kernel/prism.c` are still here for it.
Two things need reintroducing: a `video` module that initialises from
`mb->framebuffer_addr` and the pitch, and the rendering calls Prism used to
make. The serial mirror and the memory map are worth keeping either way: on a
text console they are the difference between a five minute bug and an
afternoon.