cd source                                    &&

./configure --prefix=/usr                    &&
make

make DESTDIR=$P install

