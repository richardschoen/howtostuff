# Install and configure rsync daemon on IBM i 

rsync is a Unix/Linux based file syncronization tool. The rsync daemon allows rsync to run as a TCP server on port 873. 
rsync can also be used over samba or ssh file access, but this document focuses on the rsync daemon.
There are a ton of configuration options available. This just focuses on simple examples to get you started.

Install rsync yum packages from IBM i ACS Open Source Package Management
```
Package list:
rsync
```
Log in to SSH as an IBM i user

If not started, start the bash shell by typing ***bash*** unless bash is already your default shell. 

Run the following shell command line sequence to set up the directories needed. If they already exist that's OK
```
mkdir /QOpenSys/var/run
mkdir /QOpenSys/var/log

Demo directories:

mkdir /rsyncback1
mkdir /rsyncback2

```

Make sure rsync is available in your search path or via its source path by typing the rsync command and pressing Enter.
```
rsync

-or-

/QopenSys/pkgs/bin/rsync
```

As a command response you should see something similar to the following:
```
rsync  version 3.2.3  protocol version 31
Copyright (C) 1996-2020 by Andrew Tridgell, Wayne Davison, and others.
Web site: https://rsync.samba.org/
Capabilities:
    64-bit files, 64-bit inums, 64-bit timestamps, 64-bit long ints,
    socketpairs, hardlinks, hardlink-specials, symlinks, no IPv6, atimes,
    batchfiles, inplace, append, no ACLs, no xattrs, optional protect-args,
    iconv, symtimes, no prealloc, stop-at, no crtimes
Optimizations:
    no SIMD, no asm, openssl-crypto
Checksum list:
    md5 md4 none
Compress list:
    zstd zlibx zlib none

rsync comes with ABSOLUTELY NO WARRANTY.  This is free software, and you
are welcome to redistribute it under certain conditions.  See the GNU
General Public Licence for details.

rsync is a file transfer program capable of efficient remote update
via a fast differencing algorithm.

Usage: rsync [OPTION]... SRC [SRC]... DEST
  or   rsync [OPTION]... SRC [SRC]... [USER@]HOST:DEST
  or   rsync [OPTION]... SRC [SRC]... [USER@]HOST::DEST
  or   rsync [OPTION]... SRC [SRC]... rsync://[USER@]HOST[:PORT]/DEST
  or   rsync [OPTION]... [USER@]HOST:SRC [DEST]
  or   rsync [OPTION]... [USER@]HOST::SRC [DEST]
  or   rsync [OPTION]... rsync://[USER@]HOST[:PORT]/SRC [DEST]
The ':' usages connect via remote shell, while '::' & 'rsync://' usages connect
to an rsync daemon, and require SRC or DEST to start with a module name.

Options
--verbose, -v            increase verbosity
--info=FLAGS             fine-grained informational verbosity
--debug=FLAGS            fine-grained debug verbosity
--stderr=e|a|c           change stderr output mode (default: errors)
--quiet, -q              suppress non-error messages
--no-motd                suppress daemon-mode MOTD
--checksum, -c           skip based on checksum, not mod-time & size
--archive, -a            archive mode; equals -rlptgoD (no -H,-A,-X)
--no-OPTION              turn off an implied OPTION (e.g. --no-D)
--recursive, -r          recurse into directories
--relative, -R           use relative path names
--no-implied-dirs        don't send implied dirs with --relative
--backup, -b             make backups (see --suffix & --backup-dir)
--backup-dir=DIR         make backups into hierarchy based in DIR
--suffix=SUFFIX          backup suffix (default ~ w/o --backup-dir)
--update, -u             skip files that are newer on the receiver
--inplace                update destination files in-place
--append                 append data onto shorter files
--append-verify          --append w/old data in file checksum
--dirs, -d               transfer directories without recursing
--mkpath                 create the destination's path component
--links, -l              copy symlinks as symlinks
--copy-links, -L         transform symlink into referent file/dir
--copy-unsafe-links      only "unsafe" symlinks are transformed
--safe-links             ignore symlinks that point outside the tree
--munge-links            munge symlinks to make them safe & unusable
--copy-dirlinks, -k      transform symlink to dir into referent dir
--keep-dirlinks, -K      treat symlinked dir on receiver as dir
--hard-links, -H         preserve hard links
--perms, -p              preserve permissions
--executability, -E      preserve executability
--chmod=CHMOD            affect file and/or directory permissions
--acls, -A               preserve ACLs (implies --perms)
--xattrs, -X             preserve extended attributes
--owner, -o              preserve owner (super-user only)
--group, -g              preserve group
--devices                preserve device files (super-user only)
--specials               preserve special files
-D                       same as --devices --specials
--times, -t              preserve modification times
--atimes, -U             preserve access (use) times
--open-noatime           avoid changing the atime on opened files
--crtimes, -N            preserve create times (newness)
--omit-dir-times, -O     omit directories from --times
--omit-link-times, -J    omit symlinks from --times
--super                  receiver attempts super-user activities
--fake-super             store/recover privileged attrs using xattrs
--sparse, -S             turn sequences of nulls into sparse blocks
--preallocate            allocate dest files before writing them
--write-devices          write to devices as files (implies --inplace)
--dry-run, -n            perform a trial run with no changes made
--whole-file, -W         copy files whole (w/o delta-xfer algorithm)
--checksum-choice=STR    choose the checksum algorithm (aka --cc)
--one-file-system, -x    don't cross filesystem boundaries
--block-size=SIZE, -B    force a fixed checksum block-size
--rsh=COMMAND, -e        specify the remote shell to use
--rsync-path=PROGRAM     specify the rsync to run on remote machine
--existing               skip creating new files on receiver
--ignore-existing        skip updating files that exist on receiver
--remove-source-files    sender removes synchronized files (non-dir)
--del                    an alias for --delete-during
--delete                 delete extraneous files from dest dirs
--delete-before          receiver deletes before xfer, not during
--delete-during          receiver deletes during the transfer
--delete-delay           find deletions during, delete after
--delete-after           receiver deletes after transfer, not during
--delete-excluded        also delete excluded files from dest dirs
--ignore-missing-args    ignore missing source args without error
--delete-missing-args    delete missing source args from destination
--ignore-errors          delete even if there are I/O errors
--force                  force deletion of dirs even if not empty
--max-delete=NUM         don't delete more than NUM files
--max-size=SIZE          don't transfer any file larger than SIZE
--min-size=SIZE          don't transfer any file smaller than SIZE
--max-alloc=SIZE         change a limit relating to memory alloc
--partial                keep partially transferred files
--partial-dir=DIR        put a partially transferred file into DIR
--delay-updates          put all updated files into place at end
--prune-empty-dirs, -m   prune empty directory chains from file-list
--numeric-ids            don't map uid/gid values by user/group name
--usermap=STRING         custom username mapping
--groupmap=STRING        custom groupname mapping
--chown=USER:GROUP       simple username/groupname mapping
--timeout=SECONDS        set I/O timeout in seconds
--contimeout=SECONDS     set daemon connection timeout in seconds
--ignore-times, -I       don't skip files that match size and time
--size-only              skip files that match in size
--modify-window=NUM, -@  set the accuracy for mod-time comparisons
--temp-dir=DIR, -T       create temporary files in directory DIR
--fuzzy, -y              find similar file for basis if no dest file
--compare-dest=DIR       also compare destination files relative to DIR
--copy-dest=DIR          ... and include copies of unchanged files
--link-dest=DIR          hardlink to files in DIR when unchanged
--compress, -z           compress file data during the transfer
--compress-choice=STR    choose the compression algorithm (aka --zc)
--compress-level=NUM     explicitly set compression level (aka --zl)
--skip-compress=LIST     skip compressing files with suffix in LIST
--cvs-exclude, -C        auto-ignore files in the same way CVS does
--filter=RULE, -f        add a file-filtering RULE
-F                       same as --filter='dir-merge /.rsync-filter'
                         repeated: --filter='- .rsync-filter'
--exclude=PATTERN        exclude files matching PATTERN
--exclude-from=FILE      read exclude patterns from FILE
--include=PATTERN        don't exclude files matching PATTERN
--include-from=FILE      read include patterns from FILE
--files-from=FILE        read list of source-file names from FILE
--from0, -0              all *-from/filter files are delimited by 0s
--protect-args, -s       no space-splitting; wildcard chars only
--copy-as=USER[:GROUP]   specify user & optional group for the copy
--address=ADDRESS        bind address for outgoing socket to daemon
--port=PORT              specify double-colon alternate port number
--sockopts=OPTIONS       specify custom TCP options
--blocking-io            use blocking I/O for the remote shell
--outbuf=N|L|B           set out buffering to None, Line, or Block
--stats                  give some file-transfer stats
--8-bit-output, -8       leave high-bit chars unescaped in output
--human-readable, -h     output numbers in a human-readable format
--progress               show progress during transfer
-P                       same as --partial --progress
--itemize-changes, -i    output a change-summary for all updates
--remote-option=OPT, -M  send OPTION to the remote side only
--out-format=FORMAT      output updates using the specified FORMAT
--log-file=FILE          log what we're doing to the specified FILE
--log-file-format=FMT    log updates using the specified FMT
--password-file=FILE     read daemon-access password from FILE
--early-input=FILE       use FILE for daemon's early exec input
--list-only              list the files instead of copying them
--bwlimit=RATE           limit socket I/O bandwidth
--stop-after=MINS        Stop rsync after MINS minutes have elapsed
--stop-at=y-m-dTh:m      Stop rsync at the specified point in time
--write-batch=FILE       write a batched update to FILE
--only-write-batch=FILE  like --write-batch but w/o updating dest
--read-batch=FILE        read a batched update from FILE
--protocol=NUM           force an older protocol version to be used
--iconv=CONVERT_SPEC     request charset conversion of filenames
--checksum-seed=NUM      set block/file checksum seed (advanced)
--ipv4, -4               prefer IPv4
--ipv6, -6               prefer IPv6
--version, -V            print the version + other info and exit
--help, -h (*)           show this help (* -h is help only on its own)

Use "rsync --daemon --help" to see the daemon-mode command-line options.
Please see the rsync(1) and rsyncd.conf(5) man pages for full documentation.
See https://rsync.samba.org/ for updates, bug reports, and answers
rsync error: syntax or usage error (code 1) at main.c(1732) [client=3.2.3]
```

```
TODO:
/etc/rsyncd.config
rsyncd.secrets for passwords
rsync command line to send/receive files with and without security
port restrictions
helpful links
```

## Set up sample **/etc/rsync.conf** file with NO security for initial test. Uncomment secrets file to enable security.

```
lock file = /QOpenSys/var/run/rsync.lock
log file = /QOpenSys/var/log/rsyncd.log
pid file = /QOpenSys/var/run/rsyncd.pid

[rsyncback1]
    path = /rsyncback1
    comment = Rsync backup directory 1
    read only = no
    list = yes
    uid = 0
    ##gid = 0
    read only = no
    list = yes
    # If auth users disabled, no password required
    auth users = rsyncclient
    secrets file = /etc/rsyncd.secrets

[rsyncback2]
    path = /rsyncback2
    comment = Rsync backup directory 1
    read only = no
    list = yes
    uid = 0
    ##gid = 0
    read only = no
    list = yes
    # If auth users disabled, no password required
    auth users = rsyncclient
    secrets file = /etc/rsyncd.secrets
```

## Set up sample **/etc/rsync.secrets** file to hold user/password combinations

```
rsyncclient=password1
sysop1=password2
sysop3=password3
```
## rsync PASE/QSH daemon startup

```
rsync --deamon
```

## rsync PASE/QSH daemon ending

```
kill -QUIT $( cat /QOpenSys/var/run/rsyncd.pid )
rm /QOpenSys/var/run/rsyncd.pid
**Removing the pid file is optional as it will get overwritten on next startup
```
## Transfer/send a file on the same system (localhost) as a test using rsync daemon

First create a file named ```/tmp/test.txt ``` or some other file with data in it.

Instructions and sample command list:

Export the password for user: rsyncclient to an environment variable. The rsync daemon users the RSYNC_PASSWORD environment variable. 

Run the rsync command. After it runs, the synced **test.txt** file should exist in file: **/rsyncback1/test.txt**

After running the rsync command , cleanup the RSYNC_PASSWORD environment variable.

**Note: If you comment out the **auth users** section in your **rsyncd.config** file with a #, then no security is used by the rsync daemon. Therefore no password is required. However you open your system up to security exposure. Minimally you should maybe limit which host IP addresses can access the IBM i on ```TCP/IP port 873```

```
export RSYNC_PASSWORD=password1
rsync -avz /tmp/test.txt rsync://rsyncclient@localhost/rsyncback1
export RSYNC_PASSWORD=
```

Now refer to standard rsync documentation or links below as needed for additional daemon or rsync command line options. 

Feel free to contribute links or other helpful tips. 

# Links

Rsync web site
https://rsync.samba.org
