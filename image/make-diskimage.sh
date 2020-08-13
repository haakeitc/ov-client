echo "Hello from diskimage"

cd /image
rm -f *
dd if=/dev/zero of=XenGuest1.img bs=1024k seek=6144 count=0
mkfs -t ext3 XenGuest1.img

mount -o loop XenGuest1.img /mnt

