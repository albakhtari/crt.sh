# A tool to pull all subdomains from [crt.sh](https://crt.sh)

## Requirements:

- [`gron`](https://github.com/tomnomnom/gron)

## Setup:

```bash
# Clone repository
git clone https://github.com/MisconceivedSec/crt.sh.git
cd crt.sh

# Install Setup.sh
sudo ./setup.sh install

# Uninstall crt.sh
sudo ./setup.sh uninstall
```
## Usage:

```bash
~$ crt.sh -help

===========================> crt.sh v1.0.1 <===========================
 Pull down all subdomains of domain/organization from https://crt.sh

 By: Mr. Misconception (@MisconceivedSec: GitHub, Discord, Twitter...)
=======================================================================

Usage: crt.sh [OPTIONS...]

Options:

    -h -help                                            Print this help message
    -u -update <path to crt.sh cloned repo>             Update crt.sh to latest version
    -t -target domain.com | "organization inc"          Target domain/organization
    -o -output <path to output file>                    Path to output file


# To pull all subdomains of hackerone.com and send output to /tmp/crtsh.txt:
~$ crt.sh -t hackerone.com -o /tmp/crtsh.txt

# To pull al domains of HackerOne Inc:
~$ crt.sh -t "HackerOne Inc"

# The output can be fed to other tools, such as 'gowitness' and 'httprobe'
~$ crt.sh -t hackerone.com | gowitness file -f - 
~$ crt.sh -t hackerone.com | httprobe

# Update crt.sh (include path to crt.sh repository):
~$ crt.sh -u /root/crt.sh/
```