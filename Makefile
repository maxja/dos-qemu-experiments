.PHONY: vmdrive vmimage vmsetup vmrun build run

vmdrive:
ifeq (,$(wildcard ./vm/freedos.qcow2))
	mkdir -p ./vm
	qemu-img create -f qcow2 ./vm/freedos.qcow2 256M
endif

vmimage:
ifeq (,$(wildcard ./tmp/FD13LITE.img))
	mkdir -p ./tmp
	curl -L -O https://www.ibiblio.org/pub/micro/pc-stuff/freedos/files/distributions/1.3/official/FD13-LiteUSB.zip
	unzip FD13-LiteUSB.zip -d ./tmp
	rm FD13-LiteUSB.zip
endif

# qemu-system-* [machine opts] \
#               [cpu opts] \
#               [accelerator opts] \
#               [device opts] \
#               [backend opts] \
#               [interface opts] \
#               [boot opts]

vmsetup: vmdrive vmimage
	qemu-system-i386 \
		-M pc \
		-m 32 \
		-enable-kvm \
		-rtc base=localtime \
		-device virtio-vga \
		-hda ./vm/freedos.qcow2 \
		-hdb ./tmp/FD13LITE.img \
		-k en-us \
		-boot order=c \
		-display sdl # none

vmrun:
	qemu-system-i386 \
		-M pc \
		-m 32 \
		-enable-kvm \
		-rtc base=localtime \
		-device virtio-vga \
		-hda ./vm/freedos.qcow2 \
		-drive if=ide,index=1,media=disk,format=raw,index=1,file=fat:rw:./build \
		-k en-us \
		-boot order=d,splash-time=0,strict=on \
		-display curses

build:
	nasm -o ./build/hello.com ./src/hello.asm

run:
	echo "RUN"

