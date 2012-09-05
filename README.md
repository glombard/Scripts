# My batch files, PowerShell scripts, etc.

These are scripts I use to repave my clean Windows installation.

I use the `Repave-Win8\Install-Tools-Chocolatey.cmd` batch file to install my favourite tools on a clean Windows 8 installation. This uses [NuGet Chocolatey](http://chocolatey.org) to install a few utilities from my [MyGet feed](http://www.myget.org/feed/Index/win8repavechocolatey).

`Repave-Win8\Install-Tools-Custom.cmd` performs a few settings changes and installs a few more tools with custom PowerShell scripts.

### Related links

* [Chocolatey](http://chocolatey.org/) by @ferventcoder
* [Repaving your PC the easier way](http://blog.maartenballiauw.be/post/2011/11/28/Repaving-your-PC-the-easier-way.aspx) by @maartenballiauw
* [Mastering my machine repaves with Git and PowerShell](http://www.peterprovost.org/blog/2012/04/20/mastering-my-machine-repaves-with-git-and-powershell/) by @pprovost
* [WebPICmd](http://learn.iis.net/page.aspx/1072/web-platform-installer-v4-command-line-webpicmdexe-preview-release/) - Microsoft Web Platform Installer
* [Ninite](http://www.ninite.com/) - Package several installs together into a single .EXE
* See how to install several software packages silently [here at wpkg.org](http://wpkg.org/Category:Silent_Installers) (shows the command-line arguments to use for silent install etc)
* [Unattended, A Windows deployment system](http://unattended.sourceforge.net/installers.php) - Also shows the command-line arguments for silent/unattended install for various common installer systems, and examples