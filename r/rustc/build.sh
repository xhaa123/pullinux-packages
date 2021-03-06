mkdir -p $P/opt/rustc-1.42.0             &&
ln -svfin rustc-1.42.0 $P/opt/rustc

cat << EOF > config.toml
# see config.toml.example for more possible options
# See the 8.4 book for an example using shipped LLVM
# e.g. if not installing clang, or using a version before 10.0
[llvm]
# by default, rust will build for a myriad of architectures
targets = "X86"

# When using system llvm prefer shared libraries
link-shared = true

[build]
# omit docs to save time and space (default is to build them)
docs = false

# install cargo as well as rust
extended = true

[install]
prefix = "/opt/rustc-1.42.0"
docdir = "share/doc/rustc-1.42.0"

[rust]
channel = "stable"
rpath = false

# BLFS does not install the FileCheck executable from llvm,
# so disable codegen tests
codegen-tests = false

[target.x86_64-unknown-linux-gnu]
# NB the output of llvm-config (i.e. help options) may be
# dumped to the screen when config.toml is parsed.
llvm-config = "/usr/bin/llvm-config"

[target.i686-unknown-linux-gnu]
# NB the output of llvm-config (i.e. help options) may be
# dumped to the screen when config.toml is parsed.
llvm-config = "/usr/bin/llvm-config"


EOF

export RUSTFLAGS="$RUSTFLAGS -C link-args=-lffi" &&
python3 ./x.py build --exclude src/tools/miri

export LIBSSH2_SYS_USE_PKG_CONFIG=1 &&
DESTDIR=${PWD}/install python3 ./x.py install &&
unset LIBSSH2_SYS_USE_PKG_CONFIG

chown -R root:root install &&
cp -a install/* $P/

mkdir -p $P/_install

echo "cat >> /etc/ld.so.conf << EOF" >> $P/_install/install.sh
echo "/opt/rustc/lib" >> $P/_install/install.sh
echo "" >> $P/_install/install.sh
echo "EOF" >> $P/_install/install.sh
echo "" >> $P/_install/install.sh

cat > /etc/profile.d/rustc.sh << "EOF"
# Begin /etc/profile.d/rustc.sh

pathprepend /opt/rustc/bin           PATH

# End /etc/profile.d/rustc.sh
EOF

echo "source /etc/profile.d/rustc.sh" >> $P/_install/install.sh




