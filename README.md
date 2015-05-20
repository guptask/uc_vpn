# Linux Installer for Univ. of Cincinnati VPN

I have released this under GNU Public License v2. Please feel free to 
use and share.

```bash
Download the repository : git clone https://github.com/guptask/uc_vpn
Note: Install git and lsb-release packages (if not present) before 
      proceeding.

Install UC VPN : ./uc_vpn/vpn_installer.sh <your 6+2 id>
Example: If abcdefgh is the 6+2 id, the command will be 
         ./uc_vpn/vpn_installer.sh abcdefgh

Log into UC VPN   : jnc --nox uc

Log out of UC VPN : jnc stop
Note : You might keep on seeing UC license on journal websites due to 
       delay in browser cache update.
```

