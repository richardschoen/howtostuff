# Using NFS-based image catalogs for IBM i backups

Borrowed this article from the following wikis site:   
https://try-as400.pocnet.net/index.php?title=Using_NFS-based_image_catalogs_for_backups

**Using NFS-based image catalogs for backups** is an alternative and inexpensive way to use OS provided facilities for backups. If a single tape drive would suffice for a given backup scenario, but is not viable because the machine is located in a remote location, NFS-based image catalogs might be worth considering.

<blockquote>'''Note:''' The procedures outlined below have been tested on IBM i 7.2 and 7.3. V4R5 definitely has no support for image catalogs.</blockquote>

Pro:
* No temporary local data,
** No local I/Os due to data to be backed up being copied into the backup images,
* No unnecessary transfers of image files bloated to the maximum size to the final file destination.

Con:
* Full restores require a D-mode manual IPL from the last ''Save 21''. This can be handled through copying that image to the HMC or VIOS storage, so it can be tied to an emulated optical drive. Depending on the image size, this simply might not fit onto the available space, or takes unacceptably long long to be copied. It should be possible to import the NFS exported backup directory to VIOS as an installation image collection to spare the lengthy copy, but this has not yet been tested.

## Configuring the service tools adapter on IBM i 
On IBM i, you need to establish a ''service tools adapter''. This is a virtual network IOA which is just added to the LPAR and otherwise not referenced in the OS with a line description. Configuration of this adapter is done in DST.<ref>Configuration in SST is also possible, but the menu item numbers and labels are slightly different.</ref>:
* <tt>5. Service tools device IDs</tt>,
* <tt>F13</tt>,
* Select one of the adapters shown with <tt>1</tt>.<ref>We recommend the one with the numerically higher ''Resource Name''. This is a purely cosmetic decision.</ref>
* Enter the IP configuration,
* <tt>F7</tt>,
* <tt>F17</tt>; Ping to this address from another machine connected to the network should now work.

NFS traffic for image catalogs exclusively runs through this adapter, being managed by SLIC. The "upper layer" OS components are not involved. Access to NFS catalogs is working in restricted mode, with TCP/IP being unavailable.

## Configuring the NFS-Server ==
This setup guide assumes a Linux based NFS server as backup destination.
* Install NFS server,
* configure NFS server by editing ''/etc/exports'',
* reload configuration by running <code>exportfs -ra</code>.

Example entry:
 /backups/i-backups 192.168.0.10/32(rw,no_root_squash,no_subtree_check,async)

192.168.0.10 is the address you gave to the service tools adapter in the previous step. This assures that only that IP address can actually access backup images.

The ''image catalog'' is in fact a simple ASCII text file. It
* must be named ''VOLUME_LIST'',
* has one entry per optical image in the same directory,
* optionally has a blank and the letter ''W'' to mark the respective image as writeable,
* cannot be managed through the usual image catalog commands on IBM i.

Using sparse files as images works and is highly recommended. It saves time and unneeded I/O to create the images compared to creating zero-filled images filled to the brim with zero bytes. Such files can be created with
 truncate -s 4G /backups/i-backups/20250528-1.udf

This quickly creates a file with initially 0 Bytes in size, with a maximum size of 4&thinsp;GiB. The suffix ''-1'' designates this file as a differential backup to the last full save.

You can use this example shell script to create images with ''cron'' on Linux before the backup job runs on IBM i:
```
#!/bin/bash
  
TODAY="$(date '+%Y%m%d')"
SIZE="4G"
DIR="/backups/i-backups"

if [ ! -f "${DIR}"/"${TODAY}"-1.udf ]; then
        truncate -s "${SIZE}" "${DIR}"/"${TODAY}"-1.udf

        if [ ! -f "${DIR}"/VOLUME_LIST ]; then
                echo "${TODAY}-1.udf W" > "${DIR}"/VOLUME_LIST
        else
                sed -i "1i ${TODAY}-1.udf W" "${DIR}"/VOLUME_LIST
        fi
fi

exit 0
```
You can name it ```create-imgclge-daily```.

The image catalog logic automatically on IBM i automatically loads the first entry in ''VOLUME_LIST''. Hence the shown script inserts new images at the beginning of the file.

##  Configuring IBM i 
With remote, NFS-based image catalogs, an image catalog is tied to a device file. We create the device ''optbkup01'' for that purpose:
 ```crtdevopt devd(optbkup01) online(*no) rsrcname(*vrt) lclintneta(*srvlan) rmtintneta('192.168.0.11') netimgdir('/backups/i-backups')```

192.168.0.11 is the IP address of the NFS server.

Next, we can vary on the device:
 ```vrycfg cfgobj(optbkup01) cfgtype(*dev) status(*on)```

Finally, we can look at the catalog entries:
 ```wrkimgclge imgclg(*dev) dev(optbkup01)```

Always make sure that you vary off the image catalog after usage, so changes to ''VOLUME_LIST'' will be recognized at next vary on.

## Differential saves 
Running an incremental save basically runs these steps:

* Create new image, and update ''VOLUME_LIST'' on the NFS server
* Vary on the backup device, and initialize the automatically attached first image
* ''savchgobj'' — Back up changed objects from user libraries since the last full backup
* ''savcfg'' — Back up configuration objects
* ''savsecdta'' — Back up user and access list objects
* ''savdlo'' — Back up Document Library Objects (DOS 8-character compatibility file system)
* ''sav'' — Back up IFS
* vary off the backup device

The following CL program automates these steps:
```
   PGM        /* Save Changed Stuff to an Image Catalog.            */
   DCL        VAR(&OPTDRV) TYPE(*CHAR) LEN(10) VALUE(OPTBKUP01)
   DCL        VAR(&TODAY) TYPE(*CHAR) LEN(6)
   DCL        VAR(&OPTDAT) TYPE(*CHAR) LEN(10)
/* Vary on and initialize with current date.                        */
   RTVSYSVAL  SYSVAL(QDATE) RTNVAR(&TODAY)
   CVTDAT     DATE(&TODAY) TOVAR(&OPTDAT) TOFMT(*YMD) +
                TOSEP(*NONE)
   VRYCFG     CFGOBJ(&OPTDRV) CFGTYPE(*DEV) STATUS(*ON)
   DLYJOB     DLY(15)
   INZOPT     DEV(&OPTDRV) NEWVOL(&OPTDAT) MEDFMT(*UDF) +
              VOL(*MOUNTED) CHECK(*NO) THRESHOLD(*CALC)
/* Actually save.                                                   */
   SAVCHGOBJ  OBJ(*ALL) LIB(*ALLUSR) DEV(&OPTDRV) +
                OBJJRN(*YES) VOL(&OPTDAT) ENDOPT(*LEAVE) +
                UPDHST(*NO) PRECHK(*NO) SAVACT(*SYNCLIB) +
                SAVACTWAIT(30) DTACPR(*LOW) +
                OMITLIB(SAVRST) OUTPUT(*PRINT)
   MONMSG     MSGID(CPF3774 CPF3778 CPF9845)
   MONMSG     MSGID(CPF3794) EXEC(GOTO CMDLBL(SENDMSG))
   SAVCFG     DEV(&OPTDRV) ENDOPT(*LEAVE) DTACPR(*LOW) +
                OUTPUT(*PRINT)
   SAVSECDTA  DEV(&OPTDRV) ENDOPT(*LEAVE) DTACPR(*LOW) +
                OUTPUT(*PRINT)
   SAVDLO     DLO(*CHG) DEV(&OPTDRV) ENDOPT(*LEAVE) +
                OUTPUT(*PRINT) DTACPR(*LOW)
   MONMSG     MSGID(CPF906B)
   MONMSG     MSGID(CPF6772) EXEC(GOTO CMDLBL(SENDMSG))
   SAV        DEV(('/QSYS.LIB/' *CAT &OPTDRV *TCAT +
                '.DEVD')) OBJ(('/*') ('/QSYS.LIB' *OMIT) +
                ('/QDLS' *OMIT) ('/QNTC' *OMIT) +
                ('/QFileSvr.400' *OMIT)) OUTPUT(*PRINT) +
                CHGPERIOD(*LASTSAVE) UPDHST(*NO) DTACPR(*LOW)
   MONMSG     MSGID(CPF3837 CPD37C3 CPFA09E CPD384E)
   MONMSG     MSGID(CPF6772) EXEC(GOTO CMDLBL(SENDMSG))
   GOTO       CMDLBL(END)
   SENDMSG:
   SNDMSG     MSG('Fehler aufgetreten: Sicherungsabbruch.') +
                TOUSR(QSYSOPR)
   END:
   DLYJOB     DLY(15)
/* Close device file properly                                       */
   VRYCFG     CFGOBJ(&OPTDRV) CFGTYPE(*DEV) STATUS(*OFF)
   ENDPGM
```

This CL code can be saved into e.&thinsp;g. ''qgpl/qclsrc.sav2imgclg'', compiled, and run through ''wrkjobscde'' after the cronjob above has created the new images.

## Full saves 
These are also called ''Save 21'', because it is run through item 21 in the ''save'' menu. The procedure is very much akin to incremental saves, but there are no individual calls to the various save programs.

```
   PGM        /* Vary on and inzopt optbkup01.                      */
   DCL        VAR(&OPTDRV) TYPE(*CHAR) LEN(10) VALUE(OPTBKUP01)
   DCL        VAR(&TODAY) TYPE(*CHAR) LEN(6)
   DCL        VAR(&OPTDAT) TYPE(*CHAR) LEN(10)
/* Vary on and initialize with current date.                        */
   RTVSYSVAL  SYSVAL(QDATE) RTNVAR(&TODAY)
   CVTDAT     DATE(&TODAY) TOVAR(&OPTDAT) TOFMT(*YMD) +
                TOSEP(*NONE)
   VRYCFG     CFGOBJ(&OPTDRV) CFGTYPE(*DEV) STATUS(*ON)
   DLYJOB     DLY(15)
   INZOPT     DEV(&OPTDRV) NEWVOL(&OPTDAT) MEDFMT(*UDF) +
              VOL(*MOUNTED) CHECK(*NO) THRESHOLD(*CALC)
   MONMSG     MSGID(OPT1330) EXEC(GOTO CMDLBL(SENDMSG))
   GOTO       CMDLBL(END)
   SENDMSG:
   SNDMSG     MSG('Fehler aufgetreten: Abbruch.') +
                TOUSR(QSYSOPR)
   END:
   ENDPGM
```

This CL code can be saved into e.g. ```qgpl/qclsrc.prepsav21```, compiled, and run manually after the you manually have created the new full save image.

Since Save 21 is an inherently manual process, four steps are necessary:
* Create the new full save image, and an appropriate entry in ''VOLUME_LIST'':
```
truncate -s 20G /backups/i-backups/$(date '+%Y%m%d')-0.udf
sed -i "1i $(date '+%Y%m%d')-0.udf W" /backups/i-backups/VOLUME_LIST
```
* Vary on, initialize the image by running ''prepsav21'' shown above.
* <tt>go save</tt>, type 21 and press return.
* After completion, vary off the device.
 vrycfg cfgobj(optbkup01) cfgtype(*dev) status(*off) 

Always make sure that you vary off the image catalog after usage, so changes to ''VOLUME_LIST'' will be recognized at next vary on.

## Single-file restore 
* Vary on image catalog:
 ```vrycfg cfgobj(optbkup01) cfgtype(*dev) status(*on)```

* If necessary, select backup image (by date), and load:
 ```wrkimgclge imgclg(*dev) dev(optinst01)```

* For each backed up library, a file with the same name as the library was created in the respective image.<br>To see what's in it:
 ```dspopt vol(250417) data(*savrst) path('/mylib')```

* Since ''savchgobj'' is used for backup, ''rstobj'' must be used for restoration, e.&thinsp;g.:
 ```rstobj obj(*all) savlib(mylib) dev(optbkup01) endopt(*leave) mbropt(*all) rstlib(savrst) output(*print) optfile('/mylib')```

* Vary off the image catalog:<ref>Will If this is not done, the subsequent automatic backup will fail.</ref>
 ```vrycfg cfgobj(optbkup01) cfgtype(*dev) status(*off)```

## Pitfalls 
* ''VOLUME_LIST'' is referenced only when varying on the optical device on IBM i. Changes to the file while the device is varied on are not recognized.
* Each file referenced in ''VOLUME_LIST'' '''must''' exist. If not the whole image catalog will behave erratic. ''Inzopt'' will fail with error code <code>OPT1300</code>. On the other hand, the directory ''may'' contain files not being referenced in the image catalog. These are invisible to the image catalog logic.
* <tt>ls -l</tt> on the NFS server always shows the maximum allocatable size of the images. If you want to know the actually used size, use <tt>du</tt>.

## Weblinks 
Recovering your system - IBM.com     
https://www.ibm.com/docs/en/i/7.3?topic=recovery-recovering-your-system 
IBM i save and restore using virtual optical images on an NFS server], IBM.com    
https://www.ibm.com/support/pages/ibm-i-save-and-restore-using-virtual-optical-images-nfs-server 
Immage Catalog over NFS - Discussion on midrange.com    
https://archive.midrange.com/midrange-l/202012/msg00377.html

## Footnotes 
