ln -sf /bin/true /usr/bin/xsltproc

tar -xf ../systemd-man-pages-246.tar.xz

sed '177,$ d' -i src/resolve/meson.build

sed -i 's/GROUP="render", //' rules.d/50-udev-default.rules.in

mkdir -p build
cd       build

LANG=en_US.UTF-8                    \
meson --prefix=/usr                 \
      --sysconfdir=/etc             \
      --localstatedir=/var          \
      -Dblkid=true                  \
      -Dbuildtype=release           \
      -Ddefault-dnssec=no           \
      -Dfirstboot=false             \
      -Dinstall-tests=false         \
      -Dkmod-path=/bin/kmod         \
      -Dldconfig=false              \
      -Dmount-path=/bin/mount       \
      -Drootprefix=                 \
      -Drootlibdir=/lib             \
      -Dsplit-usr=true              \
      -Dsulogin-path=/sbin/sulogin  \
      -Dsysusers=false              \
      -Dumount-path=/bin/umount     \
      -Db_lto=false                 \
      -Drpmmacrosdir=no             \
      -Dhomed=false                 \
      -Duserdb=false                \
      -Dman=true                    \
      -Ddocdir=/usr/share/doc/systemd-246 \
      ..


LANG=en_US.UTF-8 ninja

DESTDIR=$P LANG=en_US.UTF-8 ninja install

rm -f $P/usr/bin/xsltproc

mkdir -p $P/_install

cat > $P/_install/install.sh << "EOF"

systemd-machine-id-setup

systemctl preset-all

systemctl disable systemd-time-wait-sync.service

EOF

rm -f $P/usr/lib/sysctl.d/50-pid-max.conf

cat > /etc/pam.d/systemd-user << "EOF"

account  required    pam_access.so
account  include     system-account

session  required    pam_env.so
session  required    pam_limits.so
session  required    pam_unix.so
session  required    pam_loginuid.so
session  optional    pam_keyinit.so force revoke
session  optional    pam_systemd.so

auth     required    pam_deny.so
password required    pam_deny.so

EOF

