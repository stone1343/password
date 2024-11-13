# password

A very simple and flexible password generator for Windows and Linux

## Windows

Download from GitHub, then copy password.bat and password.ps1 to a location in PATH, e.g.

```bat
git clone https://github.com/stone1343/password.git
cd password
xcopy /d /y password.bat %USERPROFILE%\bin
xcopy /d /y password.ps1 %USERPROFILE%\bin

password --help
```

## Linux

Download from GitHub, then copy password.sh to a location in PATH, e.g.

```bash
git clone https://github.com/stone1343/password.git
cd password
cp -u password.sh ~/bin
chmod +x ~/bin/password.sh

password.sh --help
```
