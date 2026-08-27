## Welcome to GitHub Pages

You can use the [editor on GitHub](https://github.com/haeram27/env_shell/edit/master/README.md) to maintain and preview the content for your website in Markdown files.

Whenever you commit to this repository, GitHub Pages will run [Jekyll](https://jekyllrb.com/) to rebuild the pages in your site, from the content in your Markdown files.

### Markdown

Markdown is a lightweight and easy-to-use syntax for styling your writing. It includes conventions for

```markdown
Syntax highlighted code block

# Header 1
## Header 2
### Header 3

- Bulleted
- List

1. Numbered
2. List

**Bold** and _Italic_ and `Code` text

[Link](url) and ![Image](src)
```

For more details see [GitHub Flavored Markdown](https://guides.github.com/features/mastering-markdown/).

### Jekyll Themes

Your Pages site will use the layout and styles from the Jekyll theme you have selected in your [repository settings](https://github.com/haeram27/env_shell/settings). The name of this theme is saved in the Jekyll `_config.yml` configuration file.

### Support or Contact

Having trouble with Pages? Check out our [documentation](https://help.github.com/categories/github-pages-basics/) or [contact support](https://github.com/contact) and we’ll help you sort it out.



ubuntu@ubuntu:~$ sudo efibootmgr 
BootCurrent: 0000
Timeout: 0 seconds
BootOrder: 0003,0004,2001,2002,2003
Boot0000* EFI USB Device (SanDisk SanDisk Ultra)	UsbWwid(781,5581,0,A20043164604951)/HD(1,MBR,0x4012e69,0x800,0x1d877e0)RC
Boot0001* EFI PXE 0 for IPv4 (00-E0-4C-68-F3-24) 	PciRoot(0x0)/Pci(0x8,0x1)/Pci(0x0,0x3)/USB(1,0)/MAC(00e04c68f324,0)/IPv4(0.0.0.00.0.0.0,0,0)RC
Boot0002* EFI PXE 0 for IPv6 (00-E0-4C-68-F3-24) 	PciRoot(0x0)/Pci(0x8,0x1)/Pci(0x0,0x3)/USB(1,0)/MAC(00e04c68f324,0)/IPv6([::]:<->[::]:,0,0)RC
Boot0003* Windows Boot Manager	HD(1,GPT,e26e88f6-db61-4a4f-99dd-e2dde0fc4998,0x800,0x32000)/File(\EFI\Microsoft\Boot\bootmgfw.efi)57494e444f5753000100000088000000780000004200430044004f0042004a004500430054003d007b00390064006500610038003600320063002d0035006300640064002d0034006500370030002d0061006300630031002d006600330032006200330034003400640034003700390035007d00000000000100000010000000040000007fff0400
Boot0004* ubuntu	HD(1,GPT,e26e88f6-db61-4a4f-99dd-e2dde0fc4998,0x800,0x32000)/File(\EFI\ubuntu\shimx64.efi)
Boot2001* EFI USB Device	RC
Boot2002* EFI DVD/CDROM	RC
Boot2003* EFI Network	RC
ubuntu@ubuntu:~$ sudo efibootmgr -b Boot0004 -B
Invalid bootnum valueBoot0004
                        ^
ubuntu@ubuntu:~$ sudo efibootmgr -b 4 -B
BootCurrent: 0000
Timeout: 0 seconds
BootOrder: 0003,2001,2002,2003
Boot0000* EFI USB Device (SanDisk SanDisk Ultra)	UsbWwid(781,5581,0,A20043164604951)/HD(1,MBR,0x4012e69,0x800,0x1d877e0)RC
Boot0001* EFI PXE 0 for IPv4 (00-E0-4C-68-F3-24) 	PciRoot(0x0)/Pci(0x8,0x1)/Pci(0x0,0x3)/USB(1,0)/MAC(00e04c68f324,0)/IPv4(0.0.0.00.0.0.0,0,0)RC
Boot0002* EFI PXE 0 for IPv6 (00-E0-4C-68-F3-24) 	PciRoot(0x0)/Pci(0x8,0x1)/Pci(0x0,0x3)/USB(1,0)/MAC(00e04c68f324,0)/IPv6([::]:<->[::]:,0,0)RC
Boot0003* Windows Boot Manager	HD(1,GPT,e26e88f6-db61-4a4f-99dd-e2dde0fc4998,0x800,0x32000)/File(\EFI\Microsoft\Boot\bootmgfw.efi)57494e444f5753000100000088000000780000004200430044004f0042004a004500430054003d007b00390064006500610038003600320063002d0035006300640064002d0034006500370030002d0061006300630031002d006600330032006200330034003400640034003700390035007d00000000000100000010000000040000007fff0400
Boot2001* EFI USB Device	RC
Boot2002* EFI DVD/CDROM	RC
Boot2003* EFI Network	RC

