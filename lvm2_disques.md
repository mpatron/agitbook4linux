# LVM2 et Ubuntu 20.04 LTS

Quand on crée un VM, Ubuntu n'utilise pas la totalité du disque fourni. Il prend 4Go, ce qui est peu.

~~~bash
mickael@docker:~$ df -kh
Filesystem                         Size  Used Avail Use% Mounted on
udev                               1,9G     0  1,9G   0% /dev
tmpfs                              394M  1,1M  393M   1% /run
/dev/mapper/ubuntu--vg-ubuntu--lv  3,9G  3,8G     0 100% /
tmpfs                              2,0G     0  2,0G   0% /dev/shm
tmpfs                              5,0M     0  5,0M   0% /run/lock
tmpfs                              2,0G     0  2,0G   0% /sys/fs/cgroup
/dev/sda2                          976M  197M  713M  22% /boot
/dev/loop0                          56M   56M     0 100% /snap/core18/1885
/dev/loop2                          69M   69M     0 100% /snap/lxd/17280
/dev/loop3                          69M   69M     0 100% /snap/lxd/17299
/dev/loop1                          55M   55M     0 100% /snap/core18/1754
/dev/loop5                          31M   31M     0 100% /snap/snapd/9279
/dev/loop4                          28M   28M     0 100% /snap/snapd/7264
tmpfs                              394M     0  394M   0% /run/user/1000
mickael@docker:~$ sudo vgdisplay
  --- Volume group ---
  VG Name               ubuntu-vg
  System ID
  Format                lvm2
  Metadata Areas        1
  Metadata Sequence No  2
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                1
  Open LV               1
  Max PV                0
  Cur PV                1
  Act PV                1
  VG Size               <19,00 GiB
  PE Size               4,00 MiB
  Total PE              4863
  Alloc PE / Size       1024 / 4,00 GiB
  Free  PE / Size       3839 / <15,00 GiB
  VG UUID               jLOhyM-BhEE-yiPU-R80U-szSN-w9rJ-OnPjmK
mickael@docker:~$ sudo ls -la /dev/mapper/
total 0
drwxr-xr-x  2 root root      80 sept. 19 17:17 .
drwxr-xr-x 19 root root    4060 sept. 19 17:17 ..
crw-------  1 root root 10, 236 sept. 19 17:17 control
lrwxrwxrwx  1 root root       7 sept. 19 17:17 ubuntu--vg-ubuntu--lv -> ../dm-0
mickael@docker:~$ sudo lvextend -L +2G /dev/mapper/ubuntu--vg-ubuntu--lv
  Size of logical volume ubuntu-vg/ubuntu-lv changed from 4,00 GiB (1024 extents) to 6,00 GiB (1536 extents).
  Logical volume ubuntu-vg/ubuntu-lv successfully resized.
mickael@docker:~$ sudo resize2fs /dev/mapper/ubuntu--vg-ubuntu--lv
resize2fs 1.45.5 (07-Jan-2020)
Filesystem at /dev/mapper/ubuntu--vg-ubuntu--lv is mounted on /; on-line resizing required
old_desc_blocks = 1, new_desc_blocks = 1
The filesystem on /dev/mapper/ubuntu--vg-ubuntu--lv is now 1572864 (4k) blocks long.
mickael@docker:~$ df -kh
Filesystem                         Size  Used Avail Use% Mounted on
udev                               1,9G     0  1,9G   0% /dev
tmpfs                              394M  1,1M  393M   1% /run
/dev/mapper/ubuntu--vg-ubuntu--lv  5,9G  3,8G  1,9G  68% /
tmpfs                              2,0G     0  2,0G   0% /dev/shm
tmpfs                              5,0M     0  5,0M   0% /run/lock
tmpfs                              2,0G     0  2,0G   0% /sys/fs/cgroup
/dev/sda2                          976M  197M  713M  22% /boot
/dev/loop0                          56M   56M     0 100% /snap/core18/1885
/dev/loop2                          69M   69M     0 100% /snap/lxd/17280
/dev/loop3                          69M   69M     0 100% /snap/lxd/17299
/dev/loop1                          55M   55M     0 100% /snap/core18/1754
/dev/loop5                          31M   31M     0 100% /snap/snapd/9279
/dev/loop4                          28M   28M     0 100% /snap/snapd/7264
tmpfs                              394M     0  394M   0% /run/user/1000
~~~
