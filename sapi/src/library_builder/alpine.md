# alpine 初始化

    https://cloud-atlas.readthedocs.io/zh-cn/latest/linux/alpine_linux/alpine_install.html
    setup-alpine   （磁盘选择sys 写入磁盘)
    setup-bootable  (写入引导）
    setup-desktop   （配置桌面) ('gnome', 'plasma', 'xfce', 'mate', 'sway', 'lxqt')
                                'cinnamon', 'kde', 'lxqt', 'mate'

    # install VBoxGuestAdditions
    # https://mirrors.tuna.tsinghua.edu.cn/virtualbox/7.1.4/VBoxGuestAdditions_7.1.4.iso

    mkdir -p /mnt/cdrom
    mount /dev/cdrom /mnt/cdrom
