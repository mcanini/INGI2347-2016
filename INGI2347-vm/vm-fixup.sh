#!/bin/sh

sed -i -e 's,exit 0,,' /etc/rc.local
cat >> /etc/rc.local <<EOM
/sbin/sysctl kernel.randomize_va_space=0
/sbin/sysctl kernel.yama.protected_nonaccess_hardlinks=0
/sbin/sysctl kernel.yama.protected_sticky_symlinks=0
mount -o remount,acl /
/usr/sbin/ntpdate -p 1 time.mit.edu &
exit 0
EOM

perl -pi -e "s,kernel.yama.ptrace_scope = 1,kernel.yama.ptrace_scope = 0," /etc/sysctl.d/10-ptrace.conf
perl -pi -e "s,fs.protected_hardlinks = 1,fs.protected_hardlinks = 0," /etc/sysctl.d/10-link-restrictions.conf
perl -pi -e "s,fs.protected_symlinks = 1,fs.protected_symlinks = 0," /etc/sysctl.d/10-link-restrictions.conf

perl -pi -e "s,PermitRootLogin without-password,PermitRootLogin yes," /etc/ssh/sshd_config

cat > /etc/vim/vimrc.local <<EOM
set exrc
EOM

cat > /root/.gdbinit <<EOM
add-auto-load-safe-path /project1
EOM

cp /root/.gdbinit /home/vagrant/.gdbinit
chown vagrant. /home/vagrant/.gdbinit

echo Europe/Brussels > /etc/timezone

# At startup, ld.so loads /etc/ld.so.cache at the top of memory, and then
# proceeds to load shared libraries.  If students install other packages
# that contain ANY libraries, /etc/ld.so.cache gets re-generated, and if
# it grows past a page boundary, ld.so will use one more page for it at
# startup, and all shared libraries will shift down by one page!
#
# Crude work-around: if /etc/ld.so.cache is a directory, this prevents
# future invocations of ldconfig from creating an ld.so.cache file.
rm -f /etc/ld.so.cache
mkdir /etc/ld.so.cache


exit 0
