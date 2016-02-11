ASFLAGS := -m32
CFLAGS  := -m32 -g -std=c99 -Wall -Werror -D_GNU_SOURCE
LDFLAGS := -m32
LDLIBS  := -lcrypto
PROGS   := zookld zookfs zookd \
           zookfs-exstack zookd-exstack \
           shellcode.bin run-shellcode

ifeq ($(wildcard /usr/bin/execstack),)
  ifneq ($(wildcard /usr/sbin/execstack),)
    ifeq ($(filter /usr/sbin,$(subst :, ,$(PATH))),)
      PATH := $(PATH):/usr/sbin
    endif
  endif
endif

all: $(PROGS)
.PHONY: all

zookld zookd zookfs: %: %.o http.o
run-shellcode: %: %.o

%-exstack: %
	cp $< $@
	execstack -s $@

%.o: %.c
	$(CC) $< -c -o $@ $(CFLAGS) -fno-stack-protector

%.bin: %.o
	objcopy -S -O binary -j .text $< $@


.PHONY: check-bugs
check-bugs:
	./check-bugs.py bugs.txt

.PHONY: check-crash
check-crash: bin.tar.gz exploit-2a.py exploit-2b.py shellcode.bin
	./check-bin.sh
	tar xf bin.tar.gz
	./check-part2.sh zook-exstack.conf ./exploit-2a.py
	./check-part2.sh zook-exstack.conf ./exploit-2b.py

.PHONY: check-exstack
check-exstack: bin.tar.gz exploit-3.py shellcode.bin
	./check-bin.sh
	tar xf bin.tar.gz
	./check-part3.sh zook-exstack.conf ./exploit-3.py

.PHONY: check-zoobar
check-zoobar:
	./check_zoobar.py

.PHONY: check
check: check-zoobar check-bugs check-crash check-exstack


.PHONY: clean
clean:
	rm -f *.o *.pyc *.bin $(PROGS)


project%-handin.tgz: clean
	tar cf - `find . -type f | grep -v '^\.*$$' | grep -v '/CVS/' | grep -v '/\.svn/' | grep -v '/\.git/' | grep -v 'project[0-9].*\.tgz'` | gzip > $@

.PHONY: prepare-submit
prepare-submit: project1-handin.tgz

.PRECIOUS: project1-handin.tgz
