https://www.virtualbox.org/wiki/Downloads

下载包
https://download.virtualbox.org/virtualbox/

共享目录  加载USB
https://www.virtualbox.org/manual/ch04.html

network modes
https://www.virtualbox.org/manual/ch06.html


RemoteBox 是一个开源 VirtualBox 客户端 ,不是基于浏览器的
https://remotebox.knobgoblin.org.uk/?page=about

phpvirtualbox 是一个开源 WEB VirtualBox 客户端
https://github.com/phpvirtualbox/phpvirtualbox.git
https://github.com/studnitskiy/phpvirtualbox.git


proxmox vs virtualbox
https://www.diskinternals.com/vmfs-recovery/proxmox-vs-virtualbox/




## 开启嵌套虚拟化
    从 VirtualBox 列表中获取的正确名称
    VBoxManage list vms
    # VBoxManage modifyvm "VM_NAME" --nested-hw-virt on
    VBoxManage modifyvm ""pve"" --nested-hw-virt on


## 检查CPU是否支持虚拟化。使用命令

    cat /proc/cpuinfo | egrep 'vmx|svm'
    lsmod | grep kvm
