
mkdir -p $P/_install
cat > $P/_install/install.sh << "EOF"

groupadd -g 71 colord &&
useradd -c "Color Daemon Owner" -d /var/lib/colord -u 71 \
        -g colord -s /bin/false colord

EOF

mv po/fur.po po/ur.po &&
sed -i 's/fur/ur/' po/LINGUAS

mkdir build &&
cd build &&

meson --prefix=/usr            \
      --sysconfdir=/etc        \
      --localstatedir=/var     \
      -Ddaemon_user=colord     \
      -Dvapi=true              \
      -Dsystemd=true           \
      -Dlibcolordcompat=true   \
      -Dargyllcms_sensor=false \
      -Dbash_completion=false  \
      -Ddocs=false             \
      -Dman=false ..           &&
ninja

DESTDIR=$P ninja install

