ssh gary@192.168.0.22
#Part 1: Access a Windows share

#Install "samba-client cifs-utils"
sudo apt-get update
sudo apt-get install cifs-utils -y


mkdir ~/mntWindows/
sudo mount -t cifs //192.168.0.10/win-share ~/mntWindows/ -o username=user1 -o uid=gary

touch ~/mntWindows/test.txt

sudo umount ~/mntWindows/


#Persistance mount
#Create a cred file           
sudo mkdir /etc/samaba

#Creat a cred file and add the Windows user that has access to that share(Remove "#"" and change the user id and password accordingly): 
sudo nano /etc/samaba/windowscred-user1.cred
#username=user1
#password=******

#Set the security "read" for owner (root) and no permission for any one else
sudo chmod 400 /etc/samaba/windowscred.cred

sudo nano /etc/fstab
    #Add this line, make approiate changes to match your situation
    #//192.168.0.10/win-share      /home/gary/mntWindows     cifs    uid=gary,gid=gary,credentials=/etc/samaba/windowscred.cred 0 0

#Mounts all devices described at /etc/fstab. 
sudo mount -a
    #Note that changes to "fstab" may not take effect if the share is mounted.
    #First comment out the share in "/etc/fstab" and them
    #Unmount the share
    sudo umount ~/mntWindows/
    #If that doesn't work, reboot:
    sudo reboot

touch /home/gary/mntWindows/test2.txt

#Lists all the file systems mounted
 sudo mount -l | grep mntWindows
 

#***********************************************Part 2 Acess Linux volune fron Windows********************************************
ssh gary@192.168.0.89

#Innstall samba 
sudo apt-get install samba -y

#Create a new directory to share
sudo mkdir ~/smbshare1

sudo nano /etc/samba/smb.conf
#Add the following to the end of file
    [smbshare1]
    comment = First Share
    path = /home/gary/smbshare1
    valid users = user1
    writable = yes
    browsable = yes

#Create a new Linux user
sudo adduser user1

#Add a smb user
sudo smbpasswd -a user1


############################################################On a Linux client: 192.168.0.22  ##################################
#Mount from command line
sudo mount -t cifs //192.168.0.89/smbshare1 ~/mntLinux/ -o username=user1 -o uid=gary

sudo umount ~/mntLinux/

#Create a cred file for automatic mount
    #username=user1
	#password=

sudo nano /etc/fstab
    #Add this line
    #//192.168.0.89/smbshare1      /home/garymntLinux        cifs     uid=gary,gid=gary,credentials=/etc/samba/linuxcred.cred  0 0

sudo mount -a


########################################################On a Windows machine ########################################
net use M: \\192.168.0.89\smbshare1























#********************************************************AD-hoc***********************************************************
sudo cp /etc/fstab ~/YouTube/Video22-smb