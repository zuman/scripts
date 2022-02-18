# scripts

A list of useful scripts to make your terminal life easy.

Tried and tested in Ubuntu & Mac.

If you are facing any problems, you can reach out to me on syed.zuman.007@gmail.com

## 1.  Home directory customization

Run home/setup.sh to setup home directory.

## 2. Cloud VM initialization scripts

Run the following command to initialize your cloud VM based on Ubuntu distro. The parameters are:

<ol>
<li> username : The username to be create for the VM. </li>
<li> password : The password to be used for the username. </li>
<li> default_user : The default user to remove from the VM. </li>
</ol>

> wget -O - https://raw.githubusercontent.com/zuman/scripts/master/cloud/setup.sh | sudo bash -s -- {username} {password} {default_user}