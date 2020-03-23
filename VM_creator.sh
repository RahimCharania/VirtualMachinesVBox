#!/bin/bash


###Script For creating VM using virtualBox
##dependency: need virtualbox and virtualbox extension pack(for vnc)
#Author: Rahim Charania
#Usage : bash $0
#Date: 03/22/2020

echo "\
Creating VM:
[WARNING: Please dont leave any field Blank]
Name for VM: [ENTER]"
read i
echo \

echo "Project Name: [ENTER]"
read PROJECT
echo \

mkdir /home/$USER/"${PROJECT}"

echo "Disk Size (MB) : [ENTER]"
read SIZE
echo \


echo "Empty port for VNC on host machine: [ENTER]"
read PORT_VNC
echo \

echo "Enter Full Path to OS iso: [ENTER]"
read ISO_PATH
echo \

echo "Creating and launching VM, give me a second..."

echo \

VBoxManage createvm --name "${i}" --ostype "Linux_64" --register --basefolder /home/$USER/"${PROJECT}" 
VBoxManage modifyvm "${i}" --ioapic on --memory 1024 --vram 128 --nic1 intnet 
VBoxManage createhd --filename /home/$USER/"${PROJECT}"/"${i}"/"${i}"_DISK.vdi --size $SIZE --format VDI
VBoxManage storagectl "${i}" --name "SATA Controller" --add sata --controller IntelAhci 
echo "## sata controller create hdd on mounted space vdi"
VBoxManage storageattach "${i}" --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium /home/$USER/"${PROJECT}"/"${i}"/"${i}"_DISK.vdi 
echo "## IDE Controller create"
VBoxManage storagectl "${i}" --name "IDE Controller" --add ide --controller PIIX4
echo "## IDE controller"
VBoxManage storageattach "${i}" --storagectl "IDE Controller" --port 1 --device 0 --type dvddrive --medium ${ISO_PATH}
echo "## boot order"
VBoxManage modifyvm "${i}" --boot1 dvd --boot2 disk --boot3 none --boot4 none 
echo "## set up vnc port"
VBoxManage modifyvm "${i}" --vrde on --vrdemulticon on --vrdeport ${PORT_VNC}
echo "All Set!

Launch from your favorite VNC launcher ${HOSTNAME}:${PORT_VNC}"

echo \

	echo "Good Bye!"

echo \

nohup VBoxHeadless -startvm "${i}" > /dev/null &
