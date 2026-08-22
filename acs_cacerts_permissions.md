# As of ACS V1.1.9.14 and 1.1.9.15 there have been permissions file issues for the cacerts file.

## On MacOS make the following permission changes from the terminal

I an error on MacOS regarding cacerts permissions when starting a 5250 session using ACS V1.1.9.15.

The following command lines fixed it for my MacOS user:

```
sudo chmod 600 ~/IBM/iAccessClient/Private/richard/cacerts
```
```
sudo chmod 700 ~/IBM/iAccessClient/Private/richard
```
**Substitute your own paths to the cacerts file and directory.**

It could be that since I just copied acsbundle.jar that I missed something the installer does for us usually.
