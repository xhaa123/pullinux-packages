#KMOD
#Device Drivers  --->
#  [*] Multiple devices driver support (RAID and LVM) ---> [CONFIG_MD]
#       <*/M> Device mapper support                        [CONFIG_BLK_DEV_DM]
#       <*/M> Crypt target support                         [CONFIG_DM_CRYPT]
#
#Cryptographic API  --->
#  <*/M> XTS support                                       [CONFIG_CRYPTO_XTS]
#  <*/M> SHA224 and SHA256 digest algorithm                [CONFIG_CRYPTO_SHA256]
#  <*/M> AES cipher algorithms                             [CONFIG_CRYPTO_AES]
#  <*/M> User-space interface for symmetric key cipher algorithms
#                                                          [CONFIG_CRYPTO_USER_API_SKCIPHER]
#  For tests:
#  <*/M> Twofish cipher algorithm                          [CONFIG_CRYPTO_TWOFISH]
#

./configure --prefix=/usr &&
make

make DESTDIR=$P install


