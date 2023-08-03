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
Description: Pull all subdomains of domain/organization from https://crt.sh
Usage: ./crt.sh [OPTIONS]...
Version: 1.2

-t | -target <domain.com | "organization inc">        Target domain/organization
-o | -output <path/to/output/file>                    Path to output file
-u | -update <path/to/repo/crt.sh>                    Standalone: Update crt.sh to latest version
-h | -help                                            Standalone: Print this help message
-v | -version                                         Standalone: Print version
```

# Examples

```bash
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