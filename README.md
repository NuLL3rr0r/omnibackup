# OmniBackup: One Script to back them all up

OmniBackup is a MIT-licensed Bash script which delivers the following set of features:

* Support for *NIX operating systems (e.g. *BSD and GNU/Linux)
* Configuration and customization of backup mechanism through JSON
* Support for OpenLDAP backups
* Support for PostgreSQL backups as a whole or per database
* Support for MariaDB and MySQL backups as a whole or per database
* Support for filesystem backups with optional ability to follow symbolic links
* Support for pluggable customized scripts to extend OmniBackup functionality beyond its original design which allows support for many different backup scenarios that has not been built into OmniBackup, yet
* Backup file name tagging which allows including date, time, or host name in the archive name
* Online backup without a prerequisite to suspend any service
* Support for customized backup tasks priority order
* Support for multiple backup servers
* Ability to always keep a copy of backups offline
* Ability to keep a copy of backups offline if no backup server is available, or in case of an error such as a file transfer error
* Secure file transfer through SSH / SCP protocol
* LZMA2, gzip and bzip2 compression algorithms along with different compression levels to maintain a balance between speed and file size
* Ability to preserve permissions inside backup files
* Support for symmetric cryptography algorithms AES-128, AES-192 and AES-256 (a.k.a Rijndael or Advanced Encryption Standard)
* Random passphrase generation for encrypted backups with variable length and patterns or a unique passphrase for all backups
* Support for RSA signatures to verify the backup origin and integrity
* Passphrase encryption using RSA public keys for individual backup servers
* Backup integrity verification by offering hash algorithms such as MD4, MD5, MDC-2, RIPEMD160, SHA, SHA-1, SHA-224, SHA-256, SHA-384, SHA-512 and WHIRLPOOL
* Optional Base64 encoding
* System logs and a standalone log file including all details
* Reporting through email to a list of recipients with ability to include passphrases
* Customized mail subject for successful and failed backup operations
* Customized support message for reports
* Crontab integration
* Custom temporary / working directory
* Automatic and smart clean-up ability
* One instance only policy which avoids running multiple instances by mistake at the same time, therefore avoids system slow-down
* An example configuration file in JSON format to get you up and running



## Disclaimer

_Please be wary of the fact that this script has approximately <code>3.5 K</code> lines of Bash code and devoured hell of a time from me to write and debug. You should also consider that this is my first heavy Bash experiment and I may not write quality code in the language since I'm a newcomer to Bash. I do not claim that OmniBackup is production ready, that's why I did version the first release at <code>0.1.0</code>. Also keep in mind that OmniBackup heavily relies on 3rd-party software which increases the chance for fatal bugs, therefore losing data. So, I provide OmniBackup without any warranties, guarantees or conditions, of any kind and I accept no liability or responsibility for any misuse or damage. Please use it at your own risk and remember you are solely responsible for any resulting damage or data loss._


## Documentation

* [Message Types and Their Meanings](#MessageTypes)  
* [Requirements](#Requirements)  
* [Installation](#Installation)  
* [Configuring Temporary Directory](#ConfigTempDirectory)  
* [Configuring Compression](#ConfigCompression)  
* [Configuring Security](#ConfigSecurity)  
* [Configuring Reports](#ConfigReports)  
* [Configuring Remote Backup Servers](#ConfigRemoteBackupServers)  
* [Configuring Backup Tasks](#ConfigBackupTasks)  
* [Configuring Backup Priority and Order](#ConfigBackupPriorityOrder)  
* [Configuring OpenLDAP Backups](#ConfigOpenLdapBackups)  
* [Configuring Database Backups](#ConfigDatabaseBackups)  
* [Configuring PostgreSQL Database Backups](#ConfigPostgreSqlBackups)  
* [Configuring MariaDB and MySQL Databases Backups](#ConfigMariaDbMySqlBackups)  
* [Configuring Filesystem Backups](#ConfigFilesystemBackups)  
* [Configuring Other Backups](#ConfigMiscBackups)  
* [3rd-party Commands status codes](#Config3rdPartyCommandsStatusCode)  
* [Generating RSA Keys](#GeneratingRSAKeys)  
* [Password-less SSH Login](#PasswordlessSshLogin)  
* [SMTP Relay for Hosts with Private IPs](#SmtpRelay)  
* [First Run](#FirstRun)  
* [Crontab](#Crontab)  
* [Restore](#Restore)  
* [Restoring Encrypted Archives](#RestoringEncryptedArchives)  
* [Restoring Archives](#RestoringArchives)  
* [Restoring OpenLDAP Backups](#RestoringOpenLDAP)  
* [Restoring PostgreSQL Backups](#RestoringPostgreSQL)  
* [Restoring MariaDB or MySQL Backups](#RestoringMariaDbMySQL)  
* [Staying Away From Disaster](#StayingAwayFromDisaster)  
* [Example Report](#ExampleReport)  
* [ToDo](#ToDo)  
* [License](#License)  


<br />
<a name="MessageTypes"></a>

### Message Types and Their Meanings ###

Before we go any further, you may want to know that other than regular logs there are different kinds of messages in OmniBackup which may appear on screen, system logs or mail reports:

* <code>DEBUG</code> it's for development purpose only, so you should not see any message of this kind.
* <code>ERROR</code> some error happened, but hopefully the program is able to continue.
* <code>FATAL</code> indicates that something went south due to unrecoverable errors and the program terminates immediately.
* <code>INFO</code> informational notices to inform you about regular events inside the program.
* <code>SUCCESS</code> indicates an operation has been successful.
* <code>TRACE</code> it's for development purpose only, so you should not see any message of this kind.
* <code>WARNING</code> indicates that a dangerous situation might happen or already happened which is not desired.


<br />
<a name="Requirements"></a>

### Requirements ###

Originally OmniBackup developed on FreeBSD. Recently, I had the time to test it on Funtoo Linux (a variant of Gentoo) and without any modification to the original code it worked just fine. In my estimation, the current code should work out of the box inside any GNU/Linux distribution since I tried my best to write it in a platform-independent manner by reading pile of man pages. I assume if it works on FreeBSD it should also work on other BSDs and GNU/Linuxes. But I'm only 99.99% sure and when it comes to programming computers 0.01% human error is really too much and risky. So, I really appreciate feedbacks and possible patches or pull-requests.

Aside from Bash, OmniBackup requires other tools and utilities. Although most of these programs are found in a base installation of your operating system, it relies on a few other programs which has to be installed before you go any further. Note that if OmniBackup cannot find a program it gives you a fatal error message and exits.

Requirements for OmniBackup include:

* <code>basename</code>
* <code>bash</code> version <code>4.2+</code>
* <code>bzip2</code>
* <code>caller</code>
* <code>cat</code>
* <code>cd</code>
* <code>chown</code>
* <code>cut</code>
* <code>date</code>
* <code>dirname</code>
* <code>du</code>
* <code>echo</code>
* <code>expr</code>
* <code>flock</code>
* <code>grep</code>
* <code>gzip</code>
* <code>head</code>
* <code>hostname</code>
* <code>jq</code> version <code>1.4+</code>
* <code>logger</code>
* <code>mail</code>
* <code>mkdir</code>
* <code>mysqldump</code>
* <code>openssl</code>
* <code>pg_dump</code>
* <code>pg_dumpall</code>
* <code>printf</code>
* <code>readlink</code>
* <code>rm</code>
* <code>scp</code>
* <code>slapcat</code>
* <code>ssh</code>
* <code>strings</code>
* <code>sudo</code>
* <code>tar</code>
* <code>tr</code>
* <code>xz</code>

I should add, not all of the above dependencies are required in order for OmniBackup to work. At runtime, it dynamically decides which dependencies are required and then search for them. For example, if you did not enabled PostgreSQL database backup, it won't look for <code>pg_dump</code>, <code>pg_dumpall</code> and <code>sudo</code> binaries. Or, if you choose to go with LZMA2 compression algorithm it only looks for <code>xz</code> and ignore both <code>bzip2</code> and <code>gzip</code> binaries. Of course some of these commands like <code>cd</code> are internal and there is no need to lookup the filesystem to find them. On my FreeBSD system I only had to install the following ports in order to have all the dependencies complete:

* <code>databases/postgresql9*-client</code> one of these ports provide <code>pg_dump</code> and <code>pg_dumpall</code>
* <code>databases/mariadb*-client</code> one of these ports provides <code>mysqldump</code>
* <code>databases/mysql5*-client</code> one of these ports provides <code>mysqldump</code>
* <code>openldap24-server</code> provides <code>slapcat</code>
* <code>security/sudo</code> provides <code>sudo</code>
* <code>shells/bash</code> provides <code>bash</code>
* <code>sysutils/flock</code> probably a default on GNU/Linux, provides <code>flock</code> executable on FreeBSD
* <code>textproc/jq</code> provides <code>jq</code>

Note that from the above list <code>flock</code> and [jq](http://stedolan.github.io/jq/) are only mandatory requirements unless based on OmniBackup configurations other dependencies get pulled in. The best way to determine dependencies is to ignore the list of dependencies and first configure your OmniBackup instance. When your done with that, run OmniBackup manually for the first time. If it won't complain about any dependency then you are good to go. However, if it does, then you should resolve the dependencies one by one until you satisfy all the dependencies and good to go.

__Notes for Funtoo/Gentoo Linux:__ From the mandatory requirements list, I had to install <code>app-misc/jq</code>. All other requirements except <code>mail</code> were in place. Both <code>mail-client/mailx</code> and <code>mail-mta/ssmtp</code> provide <code>mail</code> command for you.

```
$ emerge -avt mail-client/mailx
```

or

```
$ emerge -avt mail-mta/ssmtp
```

In addition to that, running OmniBackup for the first time on Funtoo generated lots of this error:

```
logger: socket /dev/log: No such file or directory
```

To fix that install and start <code>app-admin/syslog-ng</code>:

```
$ emerge -avt app-admin/syslog-ng
$ rc-update add syslog-ng default
$ service syslog-ng start
```


<br />
<a name="Installation"></a>

### Installation

Installing OmniBackup is really easy. It consists of two files: a huge script file -- approximately <code>107 KB</code> -- named <code>backup.sh</code> which looks for the second file at runtime named <code>config.json</code>. It looks for <code>config.json</code> in the following order:

1. In the user's home directory <code>~</code> that OmniBackup runs under. e.g: <code>/root/.omnibackup/config.json</code> or <code>/home/babaei/.omnibackup/config.json</code>
2. In <code>/usr/local/etc/omnibackup/config.json</code>
3. In <code>/etc/omnibackup/config.json</code>
4. In the current directory which is the directory that OmniBackup executable itself resides

For the sake of simplicity I'll keep the <code>config.json</code> file in the same directory as the executable itself, in the rest of this document.

So, let's say I want to install OmniBackup inside <code>/usr/local/omnibackup</code>. In addition to that, I assume from now on you do everything as <code>root</code> user:

```
$ cd /usr/local/
$ git clone https://github.com/NuLL3rr0r/omnibackup.git
$ cd omnibackup
$ cp config.json.sample config.json
$ chmod u+rx,go-r,a-w backup.sh
$ chmod u+rw,go-rw,a-x config.json
```

All we did was cloning the code from GitHub, copying over the sample configuration file as a template and assigning the right permissions for both the script and configuration file. I prefer to make this files <code>root</code> accessible only, so no one else can read our configuration or modify it or even triggering the backup process.

You should avoid running the backup script in this step. As I mentioned we just copied a sample file to get you up and running. So, you should only run it after the final configurations are done, since it pickups possible dependencies from the configuration file and it may baffles you with the wrong dependencies errors. So, for now open-up the configuration file in your favorite editor and take a look.


<br />
<a name="ConfigTempDirectory"></a>

### Configuring Temporary Directory ###

The first option inside <code>config.json</code> file is <code>.temp_dir</code> which specifes the temporary or working directory for OmniBackup. <code>/var/tmp</code> seems to be a reasonable place. Feel free to adopt it according to your needs. But, if you are going to change it to a path other than <code>/var/tmp/</code> or <code>/tmp/</code> choose an empty one. Note that each time you run OmniBackup it creates a log file inside <code>/var/tmp/</code> e.g. <code>/var/tmp/backup.2015-07-31.58471.log</code>. You cannot change the path for the log files due to technical limitations. Keep in mind that OmniBackup never removes its log files due to their small footprints. They may come handy when reports won't deliver to your email.

```
{
    "temp_dir" :  "/var/tmp",
}
```


<br />
<a name="ConfigCompression"></a>

### Configuring Compression

You've been given three options for compression:

```
{
    "compression" :
    {
        "algorithm"            : "lzma2",
        "level"                : "6e",
        "preserve_permissions" : "yes"
    },
}
```

<code>.compression.algorithm</code> accepts only four possible values: <code>lzma2</code>, <code>gzip</code> and <code>bzip2</code> which determines the compression algorithm, or, you can leave it blank for no compression at all. This affects the extension of the backup file which we call archive from now on. For <code>lzma2</code> it will be <code>.tar.xz</code>, for <code>gzip</code>, <code>.tar.gz</code>, for <code>bzip2</code>, <code>tar.bz2</code> and for no compression mode it will be simply <code>.tar</code>. Also, <code>lzma2</code>, <code>gizp</code> and <code>bzip2</code> values, pull in <code>xz</code>, <code>gizp</code> and <code>bizip2</code> binaries as dependency, respectively.

<code>.compression.level</code> option accepts values between <code>1</code> to <code>9</code> for <code>gizp</code> and <code>bzip2</code> algorithms. For <code>lzma2</code> algorithm it accepts values between <code>1</code> to <code>9</code> and <code>1e</code> to <code>9e</code>. <code>e</code> stands for extreme and aggressive compression which demands more RAM and CPU cycles. In case you choose no compression mode, the <code>level</code> option will be ignored.

<code>.compression.preserve_permissions</code> is self-explanatory, it preserve the archived files permissions inside the final archive file.


<br />
<a name="ConfigSecurity"></a>

### Configuring Security

Security module provides many features that you may not notice at the first sight:

```
{
    "security" :
    {
        "checksum_algorithm" :  "sha512",

        "encryption" :
        {
            "enable"                    :  "yes",
            "key_size"                  :  "256",
            "base64_encode"             :  "no",
            "passphrase"                :  "",
            "random_passphrase_pattern" :  "print",
            "random_passphrase_length"  :  128,
            "private_key"               :  "~/keys/private.pem"
        }
    },
}
```

Please be wary, this module heavily relies on OpenSSL. So, some of the hash or encryption algorithms may not work in case you or your distribution built OpenSSL with those options excluded.

<code>.security.checksum_algorithm</code> provides various hash algorithms to verify the archive file integrity later on. <code>md4</code>, <code>md5</code>, <code>mdc2</code>, <code>ripemd160</code>, <code>sha</code>, <code>sha1</code>, <code>sha224</code>, <code>sha256</code>, <code>sha384</code>, <code>sha512</code> and <code>whirlpool</code> algorithms are all valid options and well supported. If encryption is disabled or you did not provide a private key, OmniBackup creates a checksum file with extension <code>.sum</code> which includes the archive checksum and uploads it along with your archive file. If encryption is enabled and you did provide a private key it uses the checksum file to sign the archive and instead of uploading <code>.sum</code> file, uploads the signature file with extension <code>.sign</code>, so that it can be verified using your public key at the destination. In either case OmniBackup includes the checksum in reports and send it through email to you.

<code>.security.encryption.enable</code> should either set to <code>yes</code> or <code>no</code>. If you set it to <code>no</code> the rest of the encryption options will be ignored.

<code>.security.encryption.key_size</code> only accepts <code>128</code>, <code>192</code> and <code>256</code> values which in turn enables AES-128, AES-192 and AES-256 encryption.

<code>.security.encryption.base64_encode</code> if you set it to <code>yes</code>, the encrypted archive file, signature file and the encrypted archive passphrase will be base64 encoded, otherwise they will all be in binary format which saves up disk space and bandwidth.

<code>.security.encryption.passphrase</code> is the passphrase to encrypt or decrypt archive files. If you leave it blank, OmniBackup generates a random password for each archive file. Otherwise, it uses the specified password for all archive files and ignore both <code>random_passphrase_pattern</code> and <code>random_passphrase_length</code> options. If you decide to use a unique password for all backups make sure <code>config.json</code> is only readable by its owner. If set to blank, it pulls in <code>grep</code>, <code>head</code>, <code>strings</code> and <code>tr</code> as dependency.

<code>.security.encryption.random_passphrase_pattern</code> indicates the pattern to generate a random passphrase. For more information see the documentation of [GNU](http://www.gnu.org/software/grep/manual/html_node/Character-Classes-and-Bracket-Expressions.html) and [BSD](https://www.freebsd.org/cgi/man.cgi?query=grep) implementations of <code>grep</code>:

* <code>alnum</code> Alphanumeric characters: <code>alpha</code> and <code>digit</code>; in the <code>C</code> locale and ASCII character encoding, this is the same as <code>[0-9A-Za-z]</code>.
* <code>alpha</code> Alphabetic characters: <code>lower</code> and <code>upper</code>; in the <code>C</code> locale and ASCII character encoding, this is the same as <code>[A-Za-z]</code>.
* <code>blank</code> Blank characters: space and tab.
* <code>cntrl</code> Control characters. In ASCII, these characters have octal codes <code>000</code> through <code>037</code>, and <code>177 (DEL)</code>. In other character sets, these are the equivalent characters, if any.
* <code>digit</code> Digits: <code>0 1 2 3 4 5 6 7 8 9</code>.
* <code>graph</code> Graphical characters: <code>alnum</code> and <code>punct</code>.
* <code>lower</code> Lower-case letters; in the <code>C</code> locale and ASCII character encoding, this is <code>a b c d e f g h i j k l m n o p q r s t u v w x y z</code>.
* <code>print</code> Printable characters: <code>alnum</code>, <code>punct</code>, and space.
* <code>punct</code> Punctuation characters; in the <code>C</code> locale and ASCII character encoding, this is <code>! " # $ % & ' ( ) * + , - . / : ; < = > ? @ [ \ ] ^ _ ` { | } ~</code>.
* <code>space</code> Space characters: in the <code>C</code> locale, this is tab, newline, vertical tab, form feed, carriage return, and space.
* <code>upper</code> Upper-case letters: in the <code>C</code> locale and ASCII character encoding, this is <code>A B C D E F G H I J K L M N O P Q R S T U V W X Y Z</code>.
* <code>xdigit</code> Hexadecimal digits: <code>0 1 2 3 4 5 6 7 8 9 A B C D E F a b c d e f</code>.

<code>.security.encryption.random_passphrase_length</code> a positive number bigger than <code>0</code> that indicates the length of random passphrases.

<code>.security.encryption.private_key</code> is a private key in PEM format used to sign the encrypted archive file so that anyone knows the file originated from you. Note it only accepts absolute path and relative paths starting from home folder (tilde <code>~</code>). Do not start paths relative to OmniBackup directory. Also, keep in mind that avoid space and exotic characters inside path. It's both sane and safe to only include <code>A-Z</code>, <code>a-z</code> and underscore <code>_</code> in path because I cannot guarantee its safety. We'll discuss [RSA key generation](#GeneratingRSAKeys) later on.


<br />
<a name="ConfigReports"></a>

### Configuring Reports

Reports module is here to allow you become aware of all the details of the events that happened during the backup process, through email:

```
{
    "reports" :
    {
        "mailboxes" :
        [
            {
                "email_address"      :  "backups.archive@babaei.net",
                "attach_passphrases" :  "yes"
            },
            {
                "email_address"      :  "backups.verify@babaei.net",
                "attach_passphrases" :  "no"
            }
        ],

        "subject" :
        {
            "success" :  "[{HOST_NAME} {DATE}] BACKUP REPORT / SUCCESS",
            "error"   :  "[{HOST_NAME} {DATE}] BACKUP REPORT / ERROR",
            "fatal"   :  "[{HOST_NAME} {DATE}] BACKUP REPORT / FATAL ERROR"
        },

        "support_info" :  "Have question or need technical assistance, please visit http://www.babaei.net/ or write an email to info [ at ] babaei.net."
    },
}
```

<code>.reports.mailboxes</code> is a JSON array of email addresses and their settings who will receive the backup report when it's done, either successful or failed.

<code>.reports.mailboxes.email_address</code> should be a valid email address.

<code>.reports.mailboxes.attach_passphrases</code> determines whether passphrases for archive files should be attached to the reports for that specific email or not.

<code>.reports.subject</code> provides the ability to determine the subject of reports for different scenarios that might happen during the backup process at runtime, so by looking at your inbox you immediately realize what happened and take the appropriate action if it's necessary. <code>{HOST_NAME}</code> and <code>{DATE}</code> are recognized special placeholder keywords. They will be replaced at runtime by the host name OmniBackup backup running on or the date OmniBackup instance starts backup jobs, respectively. There is also a <code>{TIME}</code> variable if one desires to include the time in the subject of the email.

<code>.reports.success</code> is the email subject when backup process finished successfully.

<code>.reports.error</code> is the email subject when at least one error happened during the backup process.

<code>.reports.fatal</code> is the email subject when backup process faced a fatal error so it could not finish the jobs.

<code>.reports.support_info</code> allows adding a customized support message to the end of the reports.

<br />
<a name="ConfigRemoteBackupServers"></a>

### Configuring Remote Backup Servers

Using the <code>.remote</code> section of the configuration file, you can configure as many as remote backup servers that you wish. If you plan to keep backup files locally, this section provides two possible ways to do that which we'll discuss later. Note that you also have to setup [password-less SSH login](#PasswordlessSshLogin) regardless of choosing a remote server or the current host as a backup server.

```
{
    "remote" :
    {
        "keep_backup_locally" :  "partial",

        "servers" :
        [
            {
                "host"                :  "10.12.0.4",
                "port"                :  "22",
                "user"                :  "babaei",
                "dir"                 :  "~/backups/{HOST_NAME}",
                "backups_to_preserve" :  7,
                "public_key"          :  "~/keys/10.12.0.4_babaei.pem"
            },
            {
                "host"                :  "example.domain",
                "port"                :  "8931",
                "user"                :  "babaei",
                "dir"                 :  "~/backups/{HOST_NAME}",
                "backups_to_preserve" :  31,
                "public_key"          :  "~/keys/example.domain_babaei.pem"
            }
        ]
    },
}
```

<code>.remote.keep_backup_locally</code> accepts four possible values.

* <code>never</code>: always remove the temporary backup file, no matter what.
* <code>error</code>: always remove the temporary backup file unless an upload error happens.
* <code>partial</code>: keep the backup file in case the upload operation for a single backup file was partially successful. This indicates that at least one upload operation for a specific backup file has been successful. So, we are sure we have the backup file on at least one of the backup servers.
* <code>success</code>: do not remove the local backup file and keep it inside <code>.temp_dir</code> directory, even in case of succeeding all upload operations. This option is one way to always keep the backup files locally although it is not recommended. If you're going to use this method anyway, it is recommended to use some other path instead of <code>/var/tmp</code> or <code>/tmp</code> as your <code>.temp_dir</code>.

* <code>.remote.servers</code> is a JSON array of backup servers. The second method to keep a copy of backup files locally is to define the current host as another remote server here which is the recommended method to do so.

* <code>.remote.servers.host</code> is the host name or IP address of a backup server.

* <code>.remote.servers.port</code> is the SSH port for that backup server.

* <code>.remote.servers.user</code> is a user with SSH access on the server.

* <code>.remote.servers.dir</code> specifies a directory in which we keep the backup files. <code>{HOST_NAME}</code> is recognized as a valid placeholder for the current host's name (not the backup server) and should be automatically replaced at runtime.

* <code>.backups_to_preserve</code> determines how many days of older backups should be kept. For example, if I set this to <code>10</code> for one of the backup servers, I should only have <code>10</code> days of backup on that server, plus today or tonight's backup. Be advised that any negative number -- e.g. <code>-1</code> -- has special meanings here. It means do not clean up any older backup, basically keep them forever.

* <code>public_key</code> is a public key in PEM format for encrypting passphrases. As you recall these passphrases are required to decrypt the archive files. If you do not specify a public key for a backup server, you do not have access to encrypted passphrases on that server. It is useful in case that you do not wish to keep the passphrases in the same place as your encrypted archive files, even the encrypted ones. I must warn and assure you, if you are using random passphrases and and you did not provide any public key here, your backups are good for nothing unless you chose to attach passphrases to at least one email in the reports section. In addition to everything, it's possible to only provide one pair of RSA keys instead of one private key and multiple public keys if you are the sole receiver of the backup files on those multiple servers. I'll describe [RSA key generation](#GeneratingRSAKeys) later.


<br />
<a name="ConfigBackupTasks"></a>

### Configuring Backup Tasks

<code>.backup</code> is the actual part of the configuration which determines what has to be backed up. I'll break it down into a few sections for the sake of simplicity.

```
{
    "backup" :
    {
        "archive_name" :  "{DATE}_{HOST_NAME}_{TAG}",
    },
}
```

<code>.backup.archive_name</code> is a pattern for archive file names. You can prefix or postfix them as you wish by modifying this option. <code>{DATE}</code> shall be replaced by the actual date that OmniBackup script started. The date format is fixed and looks like <code>YYYY-MM-DD</code>. If you need to include the time in addition to the date, a <code{TIME}></code> option is also available in <code>HH-MM-SS</code> form. <code>{HOST_NAME}</code> shall be replaced by the host name that OmniBackup runs on. <code>{TAG}</code> is an option for each item that should be backed up, so it shall be replaced with that option's value for each backup task. So, with above configuration in mind, a typical backup archive file should look like this:

    2015-07-31_blog.babaei.net_openldap-babaei-net.tar.xz

<code>2015-07-31</code>, <code>blog.babaei.net</code> and <code>openldap-babaei-net</code> are <code>{DATE}</code>, <code>{HOST_NAME}</code> and <code>{TAG}</code> in the archive file name, respectively.


<br />
<a name="ConfigBackupPriorityOrder"></a>

### Configuring Backup Priority and Order

One of the most important steps is to configure what should be backed up, in which order:

```
{
    "backup" :
    {
        "priority_order" :
        [
            "openldap",
            "database",
            "filesystem",
            "misc"
        ],
    },
}
```

<code>.backup.priority_order</code> only recognizes four elements: <code>openldap</code>, <code>database</code>, <code>filesystem</code> and <code>misc</code>. Although, they should be self-explanatory, I have to add a comment for <code>misc</code> which is a special item in this list. It allows you to run an external script and pass arguments to it. After the script is finished, OmniBackup is able to backup a directory or file as its output. So, we'll be able to plug extra scripts to OmniBackup. We will discuss this later.

In the above example, OmniBackup backups in this order: OpenLDAP, databases, filesystem and finally other customized backups. You can change the order by swapping their order of appearance. If you want for example avoid backing up, filesystem, you should remove it from this list. Otherwise, OmniBackup looks for its configuration.

Let's consider an example if I need to only backup first database and then filesystem:

```
{
    "backup" :
    {
        "priority_order" :
        [
            "database",
            "filesystem"
        ],
    },
}
```


<br />
<a name="ConfigOpenLdapBackups"></a>

### Configuring OpenLDAP Backups

This is all we need to backup OpenLDAP objects and directories using <code>slapcat</code>:

```
{
    "backup" :
    {
        "openldap" :
        {
            "tag"   :  "openldap-babaei-net",
            "user"  :  "ldap",
            "group" :  "ldap",
            "flags" :  ""
        },
    },
}
```

<code>.backup.openldap.tag</code> is used to replace <code>{TAG}</code> in <code>.backup.archive_name</code>. Since it's going to be part of a file name, it is highly recommended to avoid space or any other character that needs escaping or quotation.

<code>.backup.openldap.user</code> is optional system user to run <code>slapcat</code> under.

<code>.backup.openldap.group</code> is optional system group to run <code>slapcat</code> under.

<code>.backup.openldap.flags</code> is used to pass arguments directly to <code>slapcat</code>. If you are OK with defaults or do not have any idea what is that, just leave it as it is.


<br />
<a name="ConfigDatabaseBackups"></a>

### Configuring Database Backups

Like the general backup configuration, database section also needs specifying the types of backup jobs and their order of running:

```
{
    "backup" :
    {
        "database" :
        {
            "priority_order" :
            [
                "postgres",
                "mysql"
            ],
        },
    },
}
```

OmniBackup officially only recognizes two types of database to backup. PostgreSQL and MariaDB / MySQL. Of course, it won't stop you from writing your own backup scripts for other databases. You can plug such scripts to OmniBackup using <code>.backup.misc</code> which we'll see later.

<code>.backup.database.priority_order</code> everything for <code>.backup.priority_order</code> also applies here.


<br />
<a name="ConfigPostgreSqlBackups"></a>

### Configuring PostgreSQL Database Backups

Configuring PostgreSQL backups consists of two easy steps: first providing a user name with an optional group name and finally a list of databases to backup:

```
{
    "backup" :
    {
        "database" :
        {
            "postgres" :
            {
                "user"  :  "pgsql",
                "group" :  "pgsql",

                "databases" :
                [
                    {
                        "tag"     :  "postgres",
                        "name"    :  "*",
                        "comment" :  "All PostgreSQL databases"
                    },
                    {
                        "tag"     :  "postgres-gitlab",
                        "name"    :  "gitlab",
                        "comment" :  "GitLab database"
                    },
                    {
                        "tag"     :  "postgres-redmine",
                        "name"    :  "redmine",
                        "comment" :  "Redmine database"
                    },
                    {
                        "tag"     :  "postgres-agilo",
                        "name"    :  "agilo",
                        "comment" :  "Agilo for Trac database"
                    },
                    {
                        "tag"     :  "postgres-owncloud",
                        "name"    :  "owncloud",
                        "comment" :  "ownCloud database"
                    },
                    {
                        "tag"     :  "postgres-tracks",
                        "name"    :  "tracks",
                        "comment" :  "Get on Tracks database"
                    }
                ]
            },
        },
    },
}
```

<code>backup.database.postgres.user</code> is a system user's name which runs our PostgreSQL service. For example, on my FreeBSD system it is called <code>pgsql</code>. This user should be created by Ports, pkgng installation of PostgreSQL or whatever package manager your distro uses. It has different names on different platforms. You can figure it out by investigating <code>/etc/passwd</code> or <code>/etc/master.passwd</code>:

```
$ cat /etc/passwd
```

or

```
$ cat /etc/master.passwd
```

<code>backup.database.postgres.group</code> is a mandatory system group's name which runs our PostgreSQL service. This one is completely optional. You can figure this one out by investigating <code>/etc/group</code>.

<code>backup.database.postgres.databases</code> is a JSON array of PostgreSQL databases.

<code>backup.database.postgres.databases.tag</code> is a tag for archive file name. Everything for <code>.backup.openldap.tag</code> also applies here.

<code>backup.database.postgres.databases.name</code> is the exact database name inside your PostgreSQL instance. * means create a backup of all tables in one go, in one single dump file. I found it a best practice to have an entire database dump and a separate dump for each database. Why? Because, in one hand I sometimes forget to add new databases here, so that * takes care of that for me. On the other hand, sometimes you may face error restoring or importing back all your databases using a single dump file -- due to a bug, human error or anything --, so you have each database backup separately, then you won't loose much in such a scenario.

<code>backup.database.postgres.databases.comment</code> is used inside logs, syslogs and reports to refer to that database instead of name which is not always clear.


<br />
<a name="ConfigMariaDbMySqlBackups"></a>

### Configuring MariaDB and MySQL Databases Backups

The same as PostgreSQL goes for configuring MariaDB or MySQL databases:

```
{
    "backup" :
    {
        "database" :
        {
            "mysql" :
            {
                "user"          :  "mysql",
                "group"         :  "mysql",
                "internal_user" :  "root",

                "databases" :
                [
                    {
                        "tag"     :  "mysql",
                        "name"    :  "*",
                        "comment" :  "All MySQL databases"
                    },
                    {
                        "tag"     :  "mysql-piwik",
                        "name"    :  "piwik",
                        "comment" :  "Piwik database"
                    },
                    {
                        "tag"     :  "mysql-osticket",
                        "name"    :  "osticket",
                        "comment" :  "Piwik database"
                    }
                ]
            }
        },
    },
}
```

<code>backup.database.mysql.user</code> serves a similar purpose as <code>backup.database.postgres.user</code> except opposed to PostgreSQL this one is optional.

<code>backup.database.mysql.group</code> serves a similar purpose as <code>backup.database.postgres.group</code> and is optional.

<code>backup.database.mysql.internal_user</code> is mandatory MariaDB / MySQL internal user name - usually root - who has enough privileges to take backups.

<code>backup.database.mysql.databases</code> is a JSON array of MariaDB / MySQL databases.

<code>backup.database.mysql.databases.tag</code> is a tag for archive file name. Everything for <code>.backup.openldap.tag</code> also applies here.

<code>backup.database.mysql.databases.name</code> serves the exact same purpose as <code>backup.database.postgres.databases.name</code>.

<code>backup.database.mysql.databases.comment</code> serves the exact same purpose as <code>backup.database.postgres.databases.comment</code>.


<br />
<a name="ConfigFilesystemBackups"></a>

### Configuring Filesystem Backups

Configuring filesystem backups are much easier since it's just a list of paths (files or directories) to backup:

```
{
    "backup" :
    {
        "filesystem" :
        [
            {
                "tag"             :  "www",
                "path"            :  "/usr/local/www/nginx",
                "follow_symlinks" :  "yes",
                "comment"         :  "Web server root directory"
            },
            {
                "tag"             :  "repos",
                "path"            :  "/usr/local/gitlab",
                "follow_symlinks" :  "yes",
                "comment"         :  "GitLab repositories"
            },
            {
                "tag"             :  "mail",
                "path"            :  "/usr/local/mail",
                "follow_symlinks" :  "yes",
                "comment"         :  "Mail server root directory"
            },
            {
                "tag"             :  "etc-system",
                "path"            :  "/etc",
                "follow_symlinks" :  "yes",
                "comment"         :  "Base system configurations"
            },
            {
                "tag"             :  "etc-ports",
                "path"            :  "/usr/local/etc",
                "follow_symlinks" :  "yes",
                "comment"         :  "Installed ports configurations"
            },
            {
                "tag"             :  "loader-conf",
                "path"            :  "/boot/loader.conf",
                "follow_symlinks" :  "yes",
                "comment"         :  "System bootstrap configuration information"
            },
            {
                "tag"             :  "boot-splash",
                "path"            :  "/boot/splash.pcx",
                "follow_symlinks" :  "yes",
                "comment"         :  "Boot-time splash screen"
            },
            {
                "tag"             :  "slim-fbsd-theme",
                "path"            :  "/usr/local/share/slim/themes/fbsd",
                "follow_symlinks" :  "yes",
                "comment"         :  "FreeBSD SLiM theme"
            }
        ],
    },
}
```

<code>backup.filesystem.tag</code> serves the exact same purpose as <code>backup.openldap.tag</code>.

<code>backup.filesystem.path</code> is the path to a directory, file or symbolic link to backup.

<code>backup.filesystem.follow_symlinks</code> determines whether to follow symbolic links or leave them out from the archive.

<code>backup.filesystem.comment</code> serves the exact same purpose as <code>backup.database.postgres.databases.comment</code>.


<br />
<a name="ConfigMiscBackups"></a>

### Configuring Other Backups

Misc section allows plugging extra backup scripts to OmniBackup and capture their output as an archive. This one is also a JSON array:

```
{
    "backup" :
    {
        "misc" :
        [
            {
                "tag"                   :  "cloudflare-ip-ranges",
                "command"               :  "/usr/local/www/nginx/cron/cloudflare-ip-ranges-updater.sh",
                "args"                  :  "ipv4 ipv6",
                "path"                  :  "/usr/local/www/nginx/include/cloudflare",
                "follow_symlinks"       :  "yes",
                "remove_path_when_done" :  "no",
                "comment"               :  "CloudFlare IP database for nginx RealIP module"
            }
        ]
    },
}
```

<code>backup.misc.tag</code> serves the exact same purpose as <code>backup.openldap.tag</code>.

<code>backup.misc.command</code> is the command or script to run. Although you can use pipes, arguments or in general a complicated one-liner command it is not recommended to do so since this option does not meant for such a scenario. I highly recommend creating another script and put everything in there. If your script succeeds return <code>0</code>, if not, return none zero values such as <code>1</code>.

<code>backup.misc.args</code> is the list of arguments to pass to your script.

<code>backup.misc.path</code> is the path to a directory, file or symbolic link as external script's output to backup.

<code>backup.misc.follow_symlinks</code> determines whether to follow symbolic links or leave them out from the archive.

<code>backup.misc.remove_path_when_done</code> determines whether to remove the path or not after the external script finished it jobs successfully. Be careful with this one if you don't know what is it or its function is not clear to you, yet.

<code>backup.misc.comment</code> serves the exact same purpose as <code>backup.database.postgres.databases.comment</code>.


<br />
<a name="Config3rdPartyCommandsStatusCode"></a>

### 3rd-party Commands Status Codes

<code>.command</code> is a vital part of the configuration file and it should be present in order for OmniBackup to run properly. If its function is ambiguous to you, just leave it alone in the configuration file. That's why I put it at the end of the file, although the order does not matter in the configuration file. For two reasons OmniBackup needs this part:

- When OmniBackup runs, the first thing it looks for are its dependencies. It reads them from this list.
- When OmniBackup runs a third party command in case of failure it has to translate the return code of that command to a human understandable message. So, if you want to know what happened in case of error, you should leave this alone or extend it if you are sure about what are you doing.

For example look at the return codes for <code>jq</code>, <code>scp</code> and <code>ssh</code> commands in the following list. Note that the return codes and their equivalent messages may not be accurate. Believe me, I tried my best to find the accurate ones. If you find something inaccurate, please let me know.

```
{
    "command" :
    {
        "basename" :
        {
            "return_code" :
            {
                "rc_0"   :  "The operation completed successfully.",
                "rc_any" :  "The operation failed."
            }
        },

        "bzip2" :
        {
            "return_code" :
            {
                "rc_0"   :  "The operation completed successfully.",
                "rc_any" :  "The operation failed."
            }
        },

        "caller" :
        {
            "return_code" :
            {
                "rc_0"   :  "The operation completed successfully.",
                "rc_any" :  "The operation failed."
            }
        },

        "cat" :
        {
            "return_code" :
            {
                "rc_0"   :  "The operation completed successfully.",
                "rc_any" :  "The operation failed."
            }
        },

        "cd" :
        {
            "return_code" :
            {
                "rc_0"   :  "The operation completed successfully.",
                "rc_any" :  "The operation failed."
            }
        },

        "chown" :
        {
            "return_code" :
            {
                "rc_0"   :  "The operation completed successfully.",
                "rc_any" :  "The operation failed."
            }
        },

        "cut" :
        {
            "return_code" :
            {
                "rc_0"   :  "The operation completed successfully.",
                "rc_any" :  "The operation failed."
            }
        },

        "date" :
        {
            "return_code" :
            {
                "rc_0"   :  "The operation completed successfully.",
                "rc_any" :  "The operation failed."
            }
        },

        "du" :
        {
            "return_code" :
            {
                "rc_0"   :  "The operation completed successfully.",
                "rc_any" :  "The operation failed."
            }
        },

        "dirname" :
        {
            "return_code" :
            {
                "rc_0"   :  "The operation completed successfully.",
                "rc_any" :  "The operation failed."
            }
        },

        "echo" :
        {
            "return_code" :
            {
                "rc_0"   :  "The operation completed successfully.",
                "rc_any" :  "The operation failed."
            }
        },

        "expr" :
        {
            "return_code" :
            {
                "rc_0"   :  "The operation completed successfully.",
                "rc_any" :  "The operation failed."
            }
        },

        "flock" :
        {
            "return_code" :
            {
                "rc_0"   :  "The operation completed successfully.",
                "rc_any" :  "The operation failed."
            }
        },

        "grep" :
        {
            "return_code" :
            {
                "rc_0"   :  "The operation completed successfully.",
                "rc_any" :  "The operation failed."
            }
        },

        "gzip" :
        {
            "return_code" :
            {
                "rc_0"   :  "The operation completed successfully.",
                "rc_any" :  "The operation failed."
            }
        },

        "head" :
        {
            "return_code" :
            {
                "rc_0"   :  "The operation completed successfully.",
                "rc_any" :  "The operation failed."
            }
        },

        "hostname" :
        {
            "return_code" :
            {
                "rc_0"   :  "The operation completed successfully.",
                "rc_any" :  "The operation failed."
            }
        },

        "jq" :
        {
            "return_code" :
            {
                "rc_0"   :  "The operation completed successfully.",
                "rc_1"   :  "The last output value was either false or null.",
                "rc_2"   :  "Usage problem or system error.",
                "rc_3"   :  "Compile error,.",
                "rc_4"   :  "Parse error.",
                "rc_any" :  "The operation failed."
            }
        },

        "logger" :
        {
            "return_code" :
            {
                "rc_0"   :  "The operation completed successfully.",
                "rc_any" :  "The operation failed."
            }
        },

        "mail" :
        {
            "return_code" :
            {
                "rc_0"   :  "The operation completed successfully.",
                "rc_any" :  "The operation failed."
            }
        },

        "mkdir" :
        {
            "return_code" :
            {
                "rc_0"   :  "The operation completed successfully.",
                "rc_any" :  "The operation failed."
            }
        },

        "mysqldump" :
        {
            "return_code" :
            {
                "rc_0"   :  "The operation completed successfully.",
                "rc_any" :  "The operation failed."
            }
        },

        "openssl" :
        {
            "return_code" :
            {
                "rc_0"   :  "The operation completed successfully.",
                "rc_any" :  "The operation failed."
            }
        },

        "pg_dump" :
        {
            "return_code" :
            {
                "rc_0"   :  "The operation completed successfully.",
                "rc_any" :  "The operation failed."
            }
        },

        "pg_dumpall" :
        {
            "return_code" :
            {
                "rc_0"   :  "The operation completed successfully.",
                "rc_any" :  "The operation failed."
            }
        },

        "printf" :
        {
            "return_code" :
            {
                "rc_0"   :  "The operation completed successfully.",
                "rc_any" :  "The operation failed."
            }
        },

        "readlink" :
        {
            "return_code" :
            {
                "rc_0"   :  "The operation completed successfully.",
                "rc_any" :  "The operation failed."
            }
        },

        "rm" :
        {
            "return_code" :
            {
                "rc_0"   :  "The operation completed successfully.",
                "rc_any" :  "The operation failed."
            }
        },

        "scp" :
        {
            "return_code" :
            {
                "rc_0"   :  "Operation was successful.",
                "rc_1"   :  "General error in file copy.",
                "rc_2"   :  "Destination is not directory, but it should be.",
                "rc_3"   :  "Maximum symlink level exceeded.",
                "rc_4"   :  "Connecting to host failed.",
                "rc_5"   :  "Connection broken.",
                "rc_6"   :  "File does not exist.",
                "rc_7"   :  "No permission to access file.",
                "rc_8"   :  "General error in sftp protocol.",
                "rc_9"   :  "File transfer protocol mismatch.",
                "rc_10"  :  "No file matches a given criteria.",
                "rc_65"  :  "Host not allowed to connect.",
                "rc_66"  :  "General error in ssh protocol.",
                "rc_67"  :  "Key exchange failed.",
                "rc_68"  :  "Reserved.",
                "rc_69"  :  "MAC error.",
                "rc_70"  :  "Compression error.",
                "rc_71"  :  "Service not available.",
                "rc_72"  :  "Protocol version not supported.",
                "rc_73"  :  "Host key not verifiable.",
                "rc_74"  :  "Connection failed.",
                "rc_75"  :  "Disconnected by application.",
                "rc_76"  :  "Too many connections.",
                "rc_77"  :  "Authentication cancelled by user.",
                "rc_78"  :  "No more authentication methods available.",
                "rc_79"  :  "Invalid user name.",
                "rc_any" :  "Unknown scp error."
            }
        },

        "slapcat" :
        {
            "return_code" :
            {
                "rc_0"   :  "The operation completed successfully.",
                "rc_any" :  "The operation failed."
            }
        },

        "ssh" :
        {
            "return_code" :
            {
                "rc_0"   :  "Operation was successful.",
                "rc_1"   :  "Generic error.",
                "rc_2"   :  "Connection failed.",
                "rc_10"  :  "No file matches a given criteria.",
                "rc_65"  :  "Host not allowed to connect.",
                "rc_66"  :  "General error in ssh protocol.",
                "rc_67"  :  "Key exchange failed.",
                "rc_68"  :  "Reserved.",
                "rc_69"  :  "MAC error.",
                "rc_70"  :  "Compression error.",
                "rc_71"  :  "Service not available.",
                "rc_72"  :  "Protocol version not supported.",
                "rc_73"  :  "Host key not verifiable.",
                "rc_74"  :  "Connection failed.",
                "rc_75"  :  "Disconnected by application.",
                "rc_76"  :  "Too many connections.",
                "rc_77"  :  "Authentication cancelled by user.",
                "rc_78"  :  "No more authentication methods available.",
                "rc_79"  :  "Invalid user name.",
                "rc_255" :  "Generic ssh error.",
                "rc_any" :  "Unknown ssh error."
            }
        },

        "strings" :
        {
            "return_code" :
            {
                "rc_0"   :  "The operation completed successfully.",
                "rc_any" :  "The operation failed."
            }
        },

        "sudo" :
        {
            "return_code" :
            {
                "rc_0"   :  "The operation completed successfully.",
                "rc_any" :  "The operation failed."
            }
        },

        "tar" :
        {
            "return_code" :
            {
                "rc_0"   :  "The operation completed successfully.",
                "rc_any" :  "The operation failed."
            }
        },

        "tr" :
        {
            "return_code" :
            {
                "rc_0"   :  "The operation completed successfully.",
                "rc_any" :  "The operation failed."
            }
        },

        "xz" :
        {
            "return_code" :
            {
                "rc_0"   :  "The operation completed successfully.",
                "rc_any" :  "The operation failed."
            }
        }
    }
}
```


<br />
<a name="GeneratingRSAKeys"></a>

### Generating RSA Keys

Generating a pair of RSA keys is fairly an easy task. Just make sure you have OpenSSL installed and then we are good to go. To generate a <code>4096-bit</code> private RSA key -- since I found it fair enough in terms of both security and performance -- :

```
$ openssl genrsa -out private.pem 4096
```

To extract the public key from our private key:

```
$ openssl rsa -in private.pem -out public.pem -outform PEM -pubout
```


<br />
<a name="PasswordlessSshLogin"></a>

### Password-less SSH Login

Setting up a password-less SSH login is even easier than [Generating RSA Keys](#GeneratingRSAKeys). First, run the following command on the host which is going to run OmniBackup:

```
$ ssh-keygen -t rsa -b 4096
```

When it starts asking questions, it's possible to choose the default answers by just pressing <code>Return</code> or <code>Enter</code> key on your keyboard:

```
Generating public/private rsa key pair.
Enter file in which to save the key (/home/babaei/.ssh/id_rsa): 
Enter passphrase (empty for no passphrase): 
Enter same passphrase again: 
Your identification has been saved in /home/babaei/.ssh/id_rsa.
Your public key has been saved in /home/babaei/.ssh/id_rsa.pub.
The key fingerprint is:
e6:b1:2b:53:cd:22:0c:17:70:3f:a0:ab:c3:f4:b1:12 babaei@blog.babaei.net
The key's randomart image is:
+--[ RSA 4096]----+
|    ..o          |
|     o.o         |
|    .  .o        |
|    ...  .       |
|  E o+  So       |
| o + oooooo      |
|  = o  oo.       |
|   o  o  .       |
|       o.        |
+-----------------+
```

Then push the public key to every single remote backup server by issuing the following command, once for each server:

```
$ cat ~/.ssh/id_rsa.pub | ssh -p {SSH_PORT_NUMBER} {USER_NAME}@{HOST_NAME_OR_IP} 'cat >> ~/.ssh/authorized_keys'
```

It asks for password the first time you run the above command per each server. After that, you should be able to login to the desired remote host without being asked for a password:

```
$ ssh -p {SSH_PORT_NUMBER} {USER_NAME}@{HOST}
```


<br />
<a name="SmtpRelay"></a>

### SMTP Relay for Hosts with Private IPs

If you did not setup a mail server or your server does not have a public IP you have to use another mail server, either your own or public services such as Gmail, Yahoo Mail, Inbox.com, Outlook or any other one as SMTP relay for outgoing messages. So that OmniBackup or any other program will be able to send email through a relay. [sSMTP](https://www.freebsd.org/doc/handbook/outgoing-only.html) is such a great tool to easlity allow that.

On my FreeBSD system I have to first completely disable Sendmail which is the default MTA in a base installation of FreeBSD:

```
sendmail_enable="NO"
sendmail_submit_enable="NO"
sendmail_outbound_enable="NO"
sendmail_msp_queue_enable="NO"
```

Then we build and install <code>mail/ssmtp</code> from [Ports collection](https://www.freebsd.org/ports/):

```
$ cd /usr/ports/mail/ssmtp/
$ make config-recursive
$ make install clean
```

Or, install the binary package from [pkgng](https://www.freebsd.org/doc/handbook/pkgng-intro.html):

```
$ pkg install mail/ssmtp
```

To replace <code>sendmail</code> with <code>ssmtp</code>, either do the following:

```
$ cd /usr/ports/mail/ssmtp/
$ make replace
```

Or, change your <code>/etc/mail/mailer.conf</code> to:

```
sendmail        /usr/local/sbin/ssmtp
send-mail       /usr/local/sbin/ssmtp
mailq           /usr/local/sbin/ssmtp
newaliases      /usr/local/sbin/ssmtp
hoststat        /usr/bin/true
purgestat       /usr/bin/true
```

OK, before you can use the program, you should copy the files <code>revaliases.sample</code> and <code>ssmtp.conf.sample</code> in <code>/usr/local/etc/ssmtp</code> to <code>revaliases</code> and <code>ssmtp.conf</code> respectively, then edit them to suit your needs:

```
$ cp /usr/local/etc/ssmtp/revaliases.sample /usr/local/etc/ssmtp/revaliases
$ cp /usr/local/etc/ssmtp/ssmtp.conf.sample /usr/local/etc/ssmtp/ssmtp.conf
```

Let's assume, I have a running SMTP mail server on <code>mail.example.com</code> which allows SSL connections on port <code>465</code>. I have a working user account on this mail server called <code>email@example.com</code>.

Now, I want every message from user <code>root</code> to be sent as [Charlie Root](http://lists.freebsd.org/pipermail/freebsd-questions/2005-September/098372.html) <code>charlie.root@babaei.net</code> and every message from user <code>babaei</code> as <code>mohammad.babaei@babaei.net</code>. All other users as <code>username@babaei.net</code>. So:

```
root:charlie.root@babaei.net:mail.example.com:465
babaei:mohammad.babaei@babaei.net:mail.example.com:465
```

```
root=postmaster
mailhub=mail.example.com:465
rewriteDomain=babaei.net
hostname=blog.babaei.net
FromLineOverride=YES
UseTLS=YES
AuthUser=email@example.com
AuthPass=SECRET_PASSWORD
Debug=NO
```

Note that if you are using <code>STARTTLS</code> on another port other than <code>465</code>, you should use <code>UseSTARTTLS=YES</code> instead of <code>UseTLS=YES</code> in the above example.

There's also a security consideration in the above example. You should always keep both <code>AuthUser</code> and <code>AuthPass</code> before the <code>Debug</code> option, why? Because when it's enable it prints your user name and password in system logs.

If everything is done properly, you should be able to send an email from command line:

```
cat /etc/motd | mail -v -s "Hello, World!" your.email@target.domain
```


<br />
<a name="FirstRun"></a>

### First Run ###

OK, after taking the journey of configuring OmniBackup, now it's time to run it for the first time in order to verify it works properly.

```
$ bash /usr/local/omnibackup/backup.sh
```

The run-time flow of OmniBackup is as follows:

* OmniBackup starts by looking for its dependencies and initializing its modules through its configuration file. Most <code>FATAL</code> errors are identified at this stage. If you get a <code>FATAL</code> error it terminates with an appropriate message which points you to the root of the issue (usually configuration errors). Otherwise, you should get to the next stage.

* In this step OmniBackup tries to verify the remote backup servers connectivity and cleans-up older backups if it has to. If a connection error happens, OmniBackup ignores the error and continues to the next step. That's because it may be a temporary down-time and the the backup server might be available later.

* At this stage OmniBackup is ready to proceed with backup tasks. So, it starts the backup tasks in the order that you have specified through the configuration file. It runs each backup task one by one, compress it into an archive file and does the encryption if enabled, finally, uploads it to the backup servers. If an error other than connection errors happen, it leaves the temporary data untouched for your inspection and moves on to the next backup task. So, you have to manually clean-up those files, later on. If a connection problem to a remote server occurs it obeys <code>.backup.keep_backup_locally</code> settings.

* In the penultimate step, OmniBackup cleans-up all the temporary files unless there are errors from previous steps.

* And finally OmniBackup sends reports to the specified list of recipients in the <code>.reports</code> section of the configuration file.

Note that in any stage if a <code>FATAL</code> error happens it tries to first go to clean-up stage and send the reports. But sometimes there's a possibility for <code>FATAL</code> errors even before OmniBackup initialized successfully so the flow may not work as expected and you may not receive any reports. In such a situation manual inspection is expected.

Moreover, it's possible to interrupt or break the backup operation at any time using <code>Ctrl+C</code> or <code>SIGTERM</code>. In such a situation, OmniBackup tries to release it's lock gracefully, but you won't receive any mail reports.


<br />
<a name="Crontab"></a>

### Crontab

It is highly recommended to [learn the fundamentals of configuring cron jobs](http://www.babaei.net/blog/2015/06/11/the-proper-way-of-adding-a-cron-job/) if you are not familiar with the topic. Anyway, to schedule a backup task as user <code>root</code>:

```
$ crontab -e -u root
```

Then add the backup cron job and make sure the <code>PATH</code> variable is present with the following values:

```
SHELL=/bin/sh
PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin
MAILTO=""

# Order of crontab fields
# minute    hour    mday    month   wday    command

# OmniBackup
# at 01:00am UTC
00      01      *       *       *       /usr/local/omnibackup/backup.sh
```

To see whether the cron job was added successfully or not, you can issue the following command:

```
$ crontab -l -u root
```

In the above example I scheduled the backup task to run at <code>01:00 AM</code> and since the server timezone is UTC it will run at <code>01:00 AM UTC</code> each night. To verify whether the backup job runs properly as a cron job or not, it's possible to run OmniBackup with a limited set of environment variables:

```
$ env -i SHELL=/bin/sh PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin HOME=/root LOGNAME=Charlie /usr/local/omnibackup/backup.sh
```


<br />
<a name="Restore"></a>

### Restore

In order to restore anything backed-up by OmniBackup, the initial step is to retrieve the intended archive file from one of the remote backup servers, there are many ways to do so. The easiest that I've found is using <code>scp</code> command:

```
$ scp -P {SSH_PORT_NUMBER} {USER_NAME}@{HOST_NAME_OR_IP}:{PATH_TO_FILE} {LOCAL_TEMPORATY_PATH}
```

e.g.

```
$ mkdir -p /var/tmp/openldap-restore/
$ scp -P 22 babaei@10.12.0.4:~/backups/blog.babaei.net/openldap-babaei-net/2015-07-31_blog.babaei.net_openldap-babaei-net.tar.xz.* /var/tmp/openldap-restore/
2015-07-31_blog.babaei.net_openldap-babaei-net.tar.xz.crypt            /var/tmp/openldap-restore   100%
2015-07-31_blog.babaei.net_openldap-babaei-net.tar.xz.crypt.secret     /var/tmp/openldap-restore   100%
2015-07-31_blog.babaei.net_openldap-babaei-net.tar.xz.crypt.sign       /var/tmp/openldap-restore   100%
```

The above example retrieves three files from the remote server <code>10.12.0.4</code> by using wildcard character *, into the directory <code>/var/tmp/openldap-restore</code>. Since I enabled encryption, I need all those files.


<br />
<a name="RestoringEncryptedArchives"></a>

### Restoring Encrypted Archives

OK, depending on our encryption settings in OmniBackup's configuration file. This step may become a little bit longer or shorter.

If encryption was enabled for our archive file without a public key, OmniBackup gives us two files. They should have <code>.crypt</code> and <code>.crypt.sum</code> extensions:

```
2015-07-31_blog.babaei.net_openldap-babaei-net.tar.xz.crypt
2015-07-31_blog.babaei.net_openldap-babaei-net.tar.xz.crypt.sum
```

If we did provide a public key for a remote server, OmniBackup gives us two more files other than the actual archive file itself on that server with extensions <code>.crypt.secret</code> and <code>.crypt.sign</code> but not a <code>.crypt.sum</code> file:

```
2015-07-31_blog.babaei.net_openldap-babaei-net.tar.xz.crypt
2015-07-31_blog.babaei.net_openldap-babaei-net.tar.xz.crypt.secret
2015-07-31_blog.babaei.net_openldap-babaei-net.tar.xz.crypt.sign
```

The next step is to know whether our encrypted archive file is in binary or Base64 encoded format. If we did disable or enabled Base64 encoding at the time of archive creation it should affect all <code>.crypt</code>, <code>.crypt.secret</code> and <code>.crypt.sign</code> files together, so they are all either binary or Base64 encoded. We can use <code>file</code> utility to distinguish these two formats:

For example if it's Base64 encoded:

```
$ file 2015-07-31_blog.babaei.net_openldap-babaei-net.tar.xz.crypt
2015-07-31_blog.babaei.net_openldap-babaei-net.tar.xz.crypt: ASCII text
```

If it's binary:

```
$ file 2015-07-31_blog.babaei.net_openldap-babaei-net.tar.xz.crypt
2015-07-31_blog.babaei.net_openldap-babaei-net.tar.xz.crypt: data
```

Now, it's time to verify our archive's integrity. If you get only <code>.crypt</code> and <code>.crypt.sum</code> files, you can verify the archive integrity this way:

```
$ cat 2015-07-31_blog.babaei.net_openldap-babaei-net.tar.xz.crypt.sum
SHA512(/var/tmp/backup.2015-07-31.58471/2015-07-31_blog.babaei.net_openldap-babaei-net.tar.xz.crypt)= 94e4e827f9024df8b547aa48037bc5cef8a851702bb9b7853c8be570c2b6a97de3b0af2e5bca70c15fc94304c44810d747bce6d028f56535dd085e67d3341367
```

The contents of the <code>.sum</code> file is nothing more than a hash generated from the contents of our actual archive file. In the above example the chosen hash was SHA-512. So, we have to verify the hash this way:

```
$ openssl dgst -sha512 2015-07-31_blog.babaei.net_openldap-babaei-net.tar.xz.crypt
SHA512(2015-07-31_blog.babaei.net_openldap-babaei-net.tar.xz.crypt)= 94e4e827f9024df8b547aa48037bc5cef8a851702bb9b7853c8be570c2b6a97de3b0af2e5bca70c15fc94304c44810d747bce6d028f56535dd085e67d3341367
```

We've just reproduced the original hash and it looks exactly the same as the archived one which verifies the file integrity. But there is one flaw with encryption without a public key, we cannot be sure that someone else did not change the file and generate their own hash unless we locate the emailed report or log files and check the hash against them.

Anyway, OpenSSL has support for various hash algorithms through the following command-line parameters:

```
-md4            to use the md4 message digest algorithm
-md5            to use the md5 message digest algorithm
-mdc2           to use the mdc2 message digest algorithm
-ripemd160      to use the ripemd160 message digest algorithm
-sha            to use the sha message digest algorithm
-sha1           to use the sha1 message digest algorithm
-sha224         to use the sha224 message digest algorithm
-sha256         to use the sha256 message digest algorithm
-sha384         to use the sha384 message digest algorithm
-sha512         to use the sha512 message digest algorithm
-whirlpool      to use the whirlpool message digest algorithm
```

In addition to that, there are alternative utilities than OpenSSL to regenerate the archive hash. For example, FreeBSD provides <code>md5</code>, <code>sha1</code>, <code>sha256</code>, <code>sha512</code> and <code>rmd160</code>, while GNU/Linux provides <code>md5sum</code>, <code>sha1sum</code>, <code>sha224sum</code>, <code>sha256sum</code>, <code>sha384sum</code> and <code>sha512sum</code> utilities to do so. No matter which tool or program you use, the final results must be the same:

```
$ sha512 2015-07-31_blog.babaei.net_openldap-babaei-net.tar.xz.crypt
SHA512 (2015-07-31_blog.babaei.net_openldap-babaei-net.tar.xz.crypt) = 94e4e827f9024df8b547aa48037bc5cef8a851702bb9b7853c8be570c2b6a97de3b0af2e5bca70c15fc94304c44810d747bce6d028f56535dd085e67d3341367
```

OK, let's assume you did provide a public key for the remote backup server that you've just retrieved the archive file from. First, we have to verify the archive file's origin using the public key from OmniBackup's host (the current host). Note that this public key may not be the same as the public key provided by the remote backup server. It's a sibiling to private key in the <code>.security.encryption.private_key</code> option of OmniBackup configuration file. For the sake of simplicity, from now on I assume you only have a single pair of keys called <code>private.pem</code> and <code>public.pem</code> rather than having multiple pair of keys.

OK, the signature file for our example is <code>2015-07-31_blog.babaei.net_openldap-babaei-net.tar.xz.crypt.sign</code>. So:

For binary format:

```
$ openssl rsautl -verify -inkey public.pem -pubin -keyform PEM -in 2015-07-31_blog.babaei.net_openldap-babaei-net.tar.xz.crypt.sign
SHA512(2015-07-31_blog.babaei.net_openldap-babaei-net.tar.xz.crypt)= 94e4e827f9024df8b547aa48037bc5cef8a851702bb9b7853c8be570c2b6a97de3b0af2e5bca70c15fc94304c44810d747bce6d028f56535dd085e67d3341367
```

For Base64 encoded format:

```
$ openssl base64 -d -in 2015-07-31_blog.babaei.net_openldap-babaei-net.tar.xz.crypt.sign | openssl rsautl -verify -inkey public.pem -pubin -keyform PEM 
SHA512(2015-07-31_blog.babaei.net_openldap-babaei-net.tar.xz.crypt)= 94e4e827f9024df8b547aa48037bc5cef8a851702bb9b7853c8be570c2b6a97de3b0af2e5bca70c15fc94304c44810d747bce6d028f56535dd085e67d3341367
```

If it prints out the archive file checksum in whatever hash format you chose as archive's checksum, then the file origin is valid and OK. From here on, you can verify the archive's integrity as mentioned earlier.

If you did not use a unique password for all of your archives, we should take an extra step to retrieve the passphrase in order to be able to decrypt the archive. If you do not have a <code>.secret</code> file, you probably did not provide a public key for that server. The only way to retrieve the password is to go through your emails and find the proper report email for that archive and extract the attached password at the end of that report. If you did not allow OmniBackup to attach the passphrases to the email reports, I can only wish you the best of luck. You'll be lost forever! However, if you found it in your reports, it looks something like this depending on your chosen settings in the <code>.security.encryption</code> area of OmniBackup's configuration file:

```
[encrypted_archive.crypt](SECRET_PASSPHRASE)
e.g.
[2015-07-31_blog.babaei.net_openldap-babaei-net.tar.xz.crypt](?PL].]2IFTm*P=M7moy?4OH_VP?i^0T.oN\S04C"k8?RTyeal^H+ZF^ Gz!Ihb;n?_sgADNY-#;Nn:Hs34ybpOSmgd/9,X1Yhv:JkeE]o{Z;|!\@f*VoWo6&lmI|(vzJ)
```

For those archives that have the <code>.secret</code> file, there is another way. It's possible to decrypt and extract the passphrase from it's <code>.secret</code> file using backup server's private key. Of course, it may or may not be different than OmniBackup's private key depending on your choice to use one pair of keys for everything or multiple ones at the time of archive creation. To decrypt the passphrase:

For binary format:

```
$ openssl base64 -d -in 2015-07-31_blog.babaei.net_openldap-babaei-net.tar.xz.crypt.secret | openssl rsautl -decrypt -inkey private.pem -out 2015-07-31_blog.babaei.net_openldap-babaei-net.tar.xz.crypt.pwd
```

For Base64 encoded format:

```
$ openssl rsautl -decrypt -inkey private.pem -in 2015-07-31_blog.babaei.net_openldap-babaei-net.tar.xz.crypt.secret -out 2015-07-31_blog.babaei.net_openldap-babaei-net.tar.xz.crypt.pwd
```

OK, what we did basically is decrypting and writing the passphrase to a file with <code>.pwd</code> extension called <code>2015-07-31_blog.babaei.net_openldap-babaei-net.tar.xz.crypt.pwd</code>. We decided to write it to a file since it's a random set of characters and it may for example contain spaces at the end which is not distinguishable. However, If you would like to print it on screen instead of a file, it's possible to omit the <code>-out</code> parameter from <code>openssl</code> command line.

OK, if you recall your unique passphrase, extracted it from your email or decrypted it from a <code>.secret</code> file, now its time to decrypt the actual archive, itself.

To decrypt it from binary format, and provide the password from command line

```
$ openssl enc -aes-256-cbc -d -in 2015-07-31_blog.babaei.net_openldap-babaei-net.tar.xz.crypt -out 2015-07-31_blog.babaei.net_openldap-babaei-net.tar.xz -k {SECRET_PASSPHRASE} -md sha1
```

To decrypt it from Base64 format, and provide the password from command line

```
$ openssl enc -aes-256-cbc -d -a -in 2015-07-31_blog.babaei.net_openldap-babaei-net.tar.xz.crypt -out 2015-07-31_blog.babaei.net_openldap-babaei-net.tar.xz -k {SECRET_PASSPHRASE} -md sha1
```

To decrypt it from binary format, and provide the password from a <code>.pwd</code> file:

```
$ openssl enc -aes-256-cbc -d -in 2015-07-31_blog.babaei.net_openldap-babaei-net.tar.xz.crypt -out 2015-07-31_blog.babaei.net_openldap-babaei-net.tar.xz -pass file:"2015-07-31_blog.babaei.net_openldap-babaei-net.tar.xz.crypt.pwd" -md sha1
```

To decrypt it from Base64 format, and provide the password from a <code>.pwd</code> file:

```
$ openssl enc -aes-256-cbc -d -a -in 2015-07-31_blog.babaei.net_openldap-babaei-net.tar.xz.crypt -out 2015-07-31_blog.babaei.net_openldap-babaei-net.tar.xz -pass file:"2015-07-31_blog.babaei.net_openldap-babaei-net.tar.xz.crypt.pwd" -md sha1
```

Now we've got our achive file <code>2015-07-31_blog.babaei.net_openldap-babaei-net.tar.xz.crypt</code> decrypted as <code>2015-07-31_blog.babaei.net_openldap-babaei-net.tar.xz</code>. For instructions on how to restore it, move to the next section.


<br />
<a name="RestoringArchives"></a>

### Restoring Archives

If you did not have encryption enabled, you should have a <code>.sum</code> file along with the archive file to verify archive integrity. Please refer to the previous section in order to find out how to do that.

Depending on how we configured <code>.compression.algorithm</code> in OmniBackup's configuration file, our archive may have different extensions and formats, therefore requires different decompression algorithms. To decompress and untar our archive file:

LZMA2:

```
$ tar xvJf 2015-07-31_blog.babaei.net_openldap-babaei-net.tar.xz
```

gzip:

```
$ tar xvzf 2015-07-31_blog.babaei.net_openldap-babaei-net.tar.xz
```

bzip2:

```
$ tar xvjf 2015-07-31_blog.babaei.net_openldap-babaei-net.tar.bz2
```

No Compression:

```
$ tar xvf 2015-07-31_blog.babaei.net_openldap-babaei-net..tar
```

And if you are required to restore the permissions from archive file:

LZMA2:

```
$ tar xvJpf 2015-07-31_blog.babaei.net_openldap-babaei-net.tar.xz
```

gzip

```
$ tar xvzpf 2015-07-31_blog.babaei.net_openldap-babaei-net.tar.xz
```

bzip2:

```
$ tar xvjpf 2015-07-31_blog.babaei.net_openldap-babaei-net.tar.bz2
```

No Compression:

```
$ tar xvpf 2015-07-31_blog.babaei.net_openldap-babaei-net.tar
```

If you would like to extract the archive file in a path other than the current directory:

```
$ tar {OPTIONS} {ARCHIVE_FILE} -C /path/to/extract/to
```


<br />
<a name="RestoringOpenLDAP"></a>

### Restoring OpenLDAP ###

After [extracting the OpenLDAP archive file](#RestoringArchives), restoring OpenLDAP database is a peace of cake. On my FreeBSD system I do the following (you may want to take a backup from <code>/var/db/openldap-data</code> first):

```
$ service slapd stop
$ rm -rf /var/db/openldap-data
$ service slapd start
$ cd 2015-07-31_blog.babaei.net_openldap-babaei-net
$ slapadd -l openldap-babaei-net.ldif
$ slapcat
```

Be advised that, <code>slapd</code> service or <code>/var/db/openldap-data</code> database may have different names or paths on other operating systems.


<br />
<a name="RestoringPostgreSQL"></a>

### Restoring PostgreSQL

After [extracting the PostgreSQL archive file](#RestoringArchives), if you would like to restore your entire database backup -- named * in the configuration file -- :

```
$ cd 2015-07-31_blog.babaei.net_postgres
$ sudo -u pgsql psql -f postgres.sql postgres
```

The overall format for restoring the entire database backup is as follows:

```
$ sudo -u {PGSQL_SYSTEM_USER} psql -f {DUMPALL_FILE} postgres
```

If you would like to only restore one database for example named <code>gitlab</code>:

```
$ cd 2015-07-31_blog.babaei.net_postgres-gitlab
$ sudo -u pgsql psql gitlab < postgres-gitlab.sql
```

The overall format for restoring a single database is as follows:

```
$ sudo -u {PGSQL_SYSTEM_USER} psql {DATABASE_NAME} < {DATABASE_DUMP_FILE}
```


<br />
<a name="RestoringMariaDbMySQL"></a>

### Restoring MariaDB or MySQL

After [extracting the MariaDB or MySQL archive file](#RestoringArchives), if you would like to restore your entire database backup -- named * in the configuration file -- :

```
$ cd 2015-07-31_blog.babaei.net_mysql
$ mysql -u root -p < mysql.sql
```

If you would like to only restore one database for example named <code>piwik</code>:

```
$ cd cd 2015-07-31_blog.babaei.net_mysql-piwik
$ mysql -u root -p
MariaDB [(none)]> create database piwik;
MariaDB [piwik]> use piwik;
MariaDB [piwik]> source mysql-piwik.sql;
MariaDB [piwik]> \q
```

Note that in the above examples, <code>root</code> is not a system user and it's a MariaDB / MySQL internal user who has enough privileges to restore a database.


<br />
<a name="StayingAwayFromDisaster"></a>

### Staying Away From Disaster

_There’s an old saying “Your data is only as good as your last backup.” That’s very true. But, there’s a little known corollary to this: “Your backups are only as good as your last restore.” It’s great that you’re backing up your databases, but you need to do more. You need to test your backups._

_The ultimate test for any backup is a restore to a server, ..._

_-- [Backup Verification: Tips for Database Backup Testing, Grant Fritchey](https://www.simple-talk.com/sql/backup-and-recovery/backup-verification-tips-for-database-backup-testing/)_


<br />
<a name="ExampleReport"></a>

### Example Report

```
[Fri Jul 31 01:00:00 UTC 2015] 292 <== INFO 2076 <== This is OmniBackup v0.1.0.
[Fri Jul 31 01:00:00 UTC 2015] 2079 <== Initiating the backup process '/usr/local/omnibackup/backup.sh'...
[Fri Jul 31 01:00:00 UTC 2015] 292 <== INFO 237 <== Found command '/usr/bin/readlink'.
[Fri Jul 31 01:00:00 UTC 2015] 292 <== INFO 237 <== Found command '/usr/bin/dirname'.
[Fri Jul 31 01:00:00 UTC 2015] 292 <== INFO 237 <== Found command '/usr/bin/basename'.
[Fri Jul 31 01:00:00 UTC 2015] 2083 <== Initiating 'Logger' module...
[Fri Jul 31 01:00:00 UTC 2015] 292 <== INFO 237 <== Found command '/bin/echo'.
[Fri Jul 31 01:00:00 UTC 2015] 292 <== INFO 237 <== Found command '/usr/bin/cut'.
[Fri Jul 31 01:00:00 UTC 2015] 292 <== INFO 237 <== Found command '/usr/bin/logger'.
[Fri Jul 31 01:00:00 UTC 2015] 292 <== INFO 2085 <== 'Logger' module initialized successfully.
[Fri Jul 31 01:00:00 UTC 2015] 292 <== INFO 2086 <== Writing logs to '/var/tmp/backup.2015-07-31.58471.log'.
[Fri Jul 31 01:00:00 UTC 2015] 2095 <== Initiating 'Config' module...
[Fri Jul 31 01:00:00 UTC 2015] 292 <== INFO 237 <== Found command '/bin/cat'.
[Fri Jul 31 01:00:00 UTC 2015] 292 <== INFO 237 <== Found command '/usr/local/bin/jq'.
[Fri Jul 31 01:00:00 UTC 2015] 292 <== INFO 2103 <== 'Config' module initialized successfully.
[Fri Jul 31 01:00:00 UTC 2015] 2106 <== Translating status codes to message...
[Fri Jul 31 01:00:01 UTC 2015] 292 <== INFO 2154 <== Successfully translated status codes to message.
[Fri Jul 31 01:00:01 UTC 2015] 2157 <== Initiating 'Clean up' module...
[Fri Jul 31 01:00:01 UTC 2015] 292 <== INFO 237 <== Found command '/bin/mkdir'.
[Fri Jul 31 01:00:01 UTC 2015] 292 <== INFO 237 <== Found command '/bin/rm'.
[Fri Jul 31 01:00:01 UTC 2015] 292 <== INFO 2184 <== Temp directory '/var/tmp/backup.2015-07-31.58471' has been created and ready.
[Fri Jul 31 01:00:01 UTC 2015] 292 <== INFO 2186 <== 'Clean up' module initialized successfully.
[Fri Jul 31 01:00:01 UTC 2015] 2189 <== Initiating 'Reports' module...
[Fri Jul 31 01:00:01 UTC 2015] 292 <== INFO 237 <== Found command '/usr/bin/mail'.
[Fri Jul 31 01:00:01 UTC 2015] 292 <== INFO 237 <== Found command '/usr/bin/printf'.
[Fri Jul 31 01:00:01 UTC 2015] 292 <== INFO 2245 <== 'Reports' module initialized successfully.
[Fri Jul 31 01:00:01 UTC 2015] 292 <== INFO 237 <== Found command '/usr/local/bin/flock'.
[Fri Jul 31 01:00:01 UTC 2015] 2249 <== Trying to acquire the lock '/var/run/omnibackup.lock'...
[Fri Jul 31 01:00:01 UTC 2015] 292 <== INFO 2253 <== Successfully acquired the lock.
[Fri Jul 31 01:00:01 UTC 2015] 2259 <== Initiating 'Compression' module...
[Fri Jul 31 01:00:01 UTC 2015] 292 <== INFO 237 <== Found command '/usr/bin/tar'.
[Fri Jul 31 01:00:01 UTC 2015] 292 <== INFO 237 <== Found command '/usr/bin/xz'.
[Fri Jul 31 01:00:01 UTC 2015] 292 <== INFO 2341 <== 'Compression' module initialized successfully.
[Fri Jul 31 01:00:01 UTC 2015] 2344 <== Initiating 'Security' module...
[Fri Jul 31 01:00:01 UTC 2015] 292 <== INFO 237 <== Found command '/usr/bin/grep'.
[Fri Jul 31 01:00:01 UTC 2015] 292 <== INFO 237 <== Found command '/usr/bin/head'.
[Fri Jul 31 01:00:01 UTC 2015] 292 <== INFO 237 <== Found command '/usr/bin/strings'.
[Fri Jul 31 01:00:01 UTC 2015] 292 <== INFO 237 <== Found command '/usr/bin/tr'.
[Fri Jul 31 01:00:01 UTC 2015] 292 <== INFO 237 <== Found command '/usr/bin/openssl'.
[Fri Jul 31 01:00:01 UTC 2015] 292 <== INFO 2411 <== 'Security' module initialized successfully.
[Fri Jul 31 01:00:01 UTC 2015] 2414 <== Initiating 'Remote' module...
[Fri Jul 31 01:00:01 UTC 2015] 292 <== INFO 237 <== Found command '/usr/bin/du'.
[Fri Jul 31 01:00:02 UTC 2015] 292 <== INFO 237 <== Found command '/bin/expr'.
[Fri Jul 31 01:00:02 UTC 2015] 292 <== INFO 237 <== Found command '/usr/bin/scp'.
[Fri Jul 31 01:00:02 UTC 2015] 292 <== INFO 237 <== Found command '/usr/bin/ssh'.
[Fri Jul 31 01:00:02 UTC 2015] 292 <== INFO 2493 <== 'Remote' module initialized successfully.
[Fri Jul 31 01:00:02 UTC 2015] 2496 <== Initiating 'Backup' module...
[Fri Jul 31 01:00:02 UTC 2015] 2581 <== Initiating 'Database dump' module...
[Fri Jul 31 01:00:02 UTC 2015] 2639 <== Initiating 'PostgreSQL dump' module...
[Fri Jul 31 01:00:02 UTC 2015] 292 <== INFO 237 <== Found command '/usr/local/bin/sudo'.
[Fri Jul 31 01:00:02 UTC 2015] 292 <== INFO 237 <== Found command '/usr/local/bin/pg_dump'.
[Fri Jul 31 01:00:02 UTC 2015] 292 <== INFO 237 <== Found command '/usr/local/bin/pg_dumpall'.
[Fri Jul 31 01:00:02 UTC 2015] 292 <== INFO 2703 <== 'PostgreSQL dump' module initialized successfully.
[Fri Jul 31 01:00:02 UTC 2015] 2712 <== Initiating 'MySQL/MariaDB dump' module...
[Fri Jul 31 01:00:02 UTC 2015] 292 <== INFO 237 <== Found command '/usr/local/bin/mysqldump'.
[Fri Jul 31 01:00:02 UTC 2015] 292 <== INFO 2776 <== 'MariaDB/MySQL dump' module initialized successfully.
[Fri Jul 31 01:00:02 UTC 2015] 292 <== INFO 2780 <== 'Database dump' module initialized successfully.
[Fri Jul 31 01:00:02 UTC 2015] 2790 <== Initiating 'Filesystem backup' module...
[Fri Jul 31 01:00:02 UTC 2015] 292 <== INFO 2853 <== 'Filesystem backup' module initialized successfully.
[Fri Jul 31 01:00:02 UTC 2015] 292 <== INFO 2993 <== 'Backup' module initialized successfully.
[Fri Jul 31 01:00:02 UTC 2015] 3039 <== Checking if 'r999@10.17.0.114:203/~/backups/core.babaei.net' exists...
[Fri Jul 31 01:00:03 UTC 2015] 3052 <== Cleaning up old backups at 'r999@10.17.0.114:203/~/backups/core.babaei.net'...
[Fri Jul 31 01:00:03 UTC 2015] 3062 <== Cleaning up 'r999@10.17.0.114:203/~/backups/core.babaei.net/etc-ports/'...
[Fri Jul 31 01:00:03 UTC 2015] 3062 <== Cleaning up 'r999@10.17.0.114:203/~/backups/core.babaei.net/etc-system/'...
[Fri Jul 31 01:00:04 UTC 2015] 3062 <== Cleaning up 'r999@10.17.0.114:203/~/backups/core.babaei.net/loader-conf/'...
[Fri Jul 31 01:00:04 UTC 2015] 3062 <== Cleaning up 'r999@10.17.0.114:203/~/backups/core.babaei.net/mail/'...
[Fri Jul 31 01:00:04 UTC 2015] 3062 <== Cleaning up 'r999@10.17.0.114:203/~/backups/core.babaei.net/mysql-piwik/'...
[Fri Jul 31 01:00:05 UTC 2015] 3062 <== Cleaning up 'r999@10.17.0.114:203/~/backups/core.babaei.net/mysql/'...
[Fri Jul 31 01:00:05 UTC 2015] 3062 <== Cleaning up 'r999@10.17.0.114:203/~/backups/core.babaei.net/postgres-gitlab/'...
[Fri Jul 31 01:00:05 UTC 2015] 3062 <== Cleaning up 'r999@10.17.0.114:203/~/backups/core.babaei.net/postgres-owncloud/'...
[Fri Jul 31 01:00:06 UTC 2015] 3062 <== Cleaning up 'r999@10.17.0.114:203/~/backups/core.babaei.net/postgres-redmine/'...
[Fri Jul 31 01:00:06 UTC 2015] 3062 <== Cleaning up 'r999@10.17.0.114:203/~/backups/core.babaei.net/postgres/'...
[Fri Jul 31 01:00:06 UTC 2015] 3062 <== Cleaning up 'r999@10.17.0.114:203/~/backups/core.babaei.net/repos/'...
[Fri Jul 31 01:00:06 UTC 2015] 3062 <== Cleaning up 'r999@10.17.0.114:203/~/backups/core.babaei.net/www/'...
[Fri Jul 31 01:00:07 UTC 2015] 1853 <== Creating a backup from 'All PostgreSQL databases'...
[Fri Jul 31 01:00:07 UTC 2015] 1867 <== Dumping 'postgres::'*'' to '/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_postgres/postgres.sql'...
[Fri Jul 31 01:00:08 UTC 2015] 1463 <== Creating archive '/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_postgres.tar.xz'...
[Fri Jul 31 01:00:08 UTC 2015] 1474 <== Removing '2015-07-31_core.babaei.net_postgres'...
[Fri Jul 31 01:00:08 UTC 2015] 1493 <== Generating a random passphrase for '/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_postgres.tar.xz'...
[Fri Jul 31 01:00:08 UTC 2015] 1542 <== Encrypting '/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_postgres.tar.xz'...
[Fri Jul 31 01:00:08 UTC 2015] 1552 <== Removing '/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_postgres.tar.xz'...
[Fri Jul 31 01:00:08 UTC 2015] 1562 <== Generating archive checksum '/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_postgres.tar.xz.crypt.sum'...
[Fri Jul 31 01:00:08 UTC 2015] 1581 <== SHA512(/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_postgres.tar.xz.crypt)= 0d4caeb42692dbb5595df82b53c3ff3d14687525eca8ca153470b18aea4b8e8922968e561def455968923772b8886660d91a398838cc4a307a4a0e5513d3dab5
[Fri Jul 31 01:00:08 UTC 2015] 1647 <== Uploading 'All PostgreSQL databases'...
[Fri Jul 31 01:00:08 UTC 2015] 1268 <== Checking if 'r999@10.17.0.114:203/~/backups/core.babaei.net/postgres/2015-07-31' exists...
[Fri Jul 31 01:00:09 UTC 2015] 1275 <== Creating 'r999@10.17.0.114:203/~/backups/core.babaei.net/postgres/2015-07-31'
[Fri Jul 31 01:00:09 UTC 2015] 1295 <== Uploading to 'r999@10.17.0.114:203/~/backups/core.babaei.net/postgres/2015-07-31'...
[Fri Jul 31 01:00:09 UTC 2015] 1300 <== Uploading '/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_postgres.tar.xz.crypt'... ~  56K
[Fri Jul 31 01:00:09 UTC 2015] 1370 <== Uploading '/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_postgres.tar.xz.crypt.sum'... ~ 4.0K
[Fri Jul 31 01:00:10 UTC 2015] 1690 <== Removing '/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_postgres.tar.xz.crypt.sum'...
[Fri Jul 31 01:00:10 UTC 2015] 1696 <== Removing '/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_postgres.tar.xz.crypt'...
[Fri Jul 31 01:00:10 UTC 2015] 1708 <== Removing '/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_postgres.tar.xz.key'...
[Fri Jul 31 01:00:10 UTC 2015] 300 <== SUCCESS 1878 <== 'All PostgreSQL databases' backup completed successfully.
[Fri Jul 31 01:00:10 UTC 2015] 1853 <== Creating a backup from 'GitLab database'...
[Fri Jul 31 01:00:10 UTC 2015] 1867 <== Dumping 'postgres::gitlabhq_production' to '/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_postgres-gitlab/postgres-gitlab.sql'...
[Fri Jul 31 01:00:10 UTC 2015] 1463 <== Creating archive '/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_postgres-gitlab.tar.xz'...
[Fri Jul 31 01:00:10 UTC 2015] 1474 <== Removing '2015-07-31_core.babaei.net_postgres-gitlab'...
[Fri Jul 31 01:00:10 UTC 2015] 1493 <== Generating a random passphrase for '/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_postgres-gitlab.tar.xz'...
[Fri Jul 31 01:00:10 UTC 2015] 1542 <== Encrypting '/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_postgres-gitlab.tar.xz'...
[Fri Jul 31 01:00:10 UTC 2015] 1552 <== Removing '/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_postgres-gitlab.tar.xz'...
[Fri Jul 31 01:00:10 UTC 2015] 1562 <== Generating archive checksum '/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_postgres-gitlab.tar.xz.crypt.sum'...
[Fri Jul 31 01:00:10 UTC 2015] 1581 <== SHA512(/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_postgres-gitlab.tar.xz.crypt)= 94e4e827f9024df8b547aa48037bc5cef8a851702bb9b7853c8be570c2b6a97de3b0af2e5bca70c15fc94304c44810d747bce6d028f56535dd085e67d3341367
[Fri Jul 31 01:00:10 UTC 2015] 1647 <== Uploading 'GitLab database'...
[Fri Jul 31 01:00:10 UTC 2015] 1268 <== Checking if 'r999@10.17.0.114:203/~/backups/core.babaei.net/postgres-gitlab/2015-07-31' exists...
[Fri Jul 31 01:00:11 UTC 2015] 1275 <== Creating 'r999@10.17.0.114:203/~/backups/core.babaei.net/postgres-gitlab/2015-07-31'
[Fri Jul 31 01:00:11 UTC 2015] 1295 <== Uploading to 'r999@10.17.0.114:203/~/backups/core.babaei.net/postgres-gitlab/2015-07-31'...
[Fri Jul 31 01:00:11 UTC 2015] 1300 <== Uploading '/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_postgres-gitlab.tar.xz.crypt'... ~  32K
[Fri Jul 31 01:00:11 UTC 2015] 1370 <== Uploading '/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_postgres-gitlab.tar.xz.crypt.sum'... ~ 4.0K
[Fri Jul 31 01:00:11 UTC 2015] 1690 <== Removing '/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_postgres-gitlab.tar.xz.crypt.sum'...
[Fri Jul 31 01:00:11 UTC 2015] 1696 <== Removing '/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_postgres-gitlab.tar.xz.crypt'...
[Fri Jul 31 01:00:11 UTC 2015] 1708 <== Removing '/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_postgres-gitlab.tar.xz.key'...
[Fri Jul 31 01:00:11 UTC 2015] 300 <== SUCCESS 1878 <== 'GitLab database' backup completed successfully.
[Fri Jul 31 01:00:11 UTC 2015] 1853 <== Creating a backup from 'Redmine database'...
[Fri Jul 31 01:00:11 UTC 2015] 1867 <== Dumping 'postgres::redmine' to '/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_postgres-redmine/postgres-redmine.sql'...
[Fri Jul 31 01:00:12 UTC 2015] 1463 <== Creating archive '/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_postgres-redmine.tar.xz'...
[Fri Jul 31 01:00:12 UTC 2015] 1474 <== Removing '2015-07-31_core.babaei.net_postgres-redmine'...
[Fri Jul 31 01:00:12 UTC 2015] 1493 <== Generating a random passphrase for '/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_postgres-redmine.tar.xz'...
[Fri Jul 31 01:00:12 UTC 2015] 1542 <== Encrypting '/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_postgres-redmine.tar.xz'...
[Fri Jul 31 01:00:12 UTC 2015] 1552 <== Removing '/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_postgres-redmine.tar.xz'...
[Fri Jul 31 01:00:12 UTC 2015] 1562 <== Generating archive checksum '/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_postgres-redmine.tar.xz.crypt.sum'...
[Fri Jul 31 01:00:12 UTC 2015] 1581 <== SHA512(/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_postgres-redmine.tar.xz.crypt)= 13edd1c5bf9cd70f172f9daf5dd632661a8c228cd310086001afeae3f1bc71cdc2de1af69423f5d645d13b09fff68455e80400880d8523a74794b41acfb346e1
[Fri Jul 31 01:00:12 UTC 2015] 1647 <== Uploading 'Redmine database'...
[Fri Jul 31 01:00:12 UTC 2015] 1268 <== Checking if 'r999@10.17.0.114:203/~/backups/core.babaei.net/postgres-redmine/2015-07-31' exists...
[Fri Jul 31 01:00:12 UTC 2015] 1275 <== Creating 'r999@10.17.0.114:203/~/backups/core.babaei.net/postgres-redmine/2015-07-31'
[Fri Jul 31 01:00:13 UTC 2015] 1295 <== Uploading to 'r999@10.17.0.114:203/~/backups/core.babaei.net/postgres-redmine/2015-07-31'...
[Fri Jul 31 01:00:13 UTC 2015] 1300 <== Uploading '/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_postgres-redmine.tar.xz.crypt'... ~  16K
[Fri Jul 31 01:00:13 UTC 2015] 1370 <== Uploading '/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_postgres-redmine.tar.xz.crypt.sum'... ~ 4.0K
[Fri Jul 31 01:00:13 UTC 2015] 1690 <== Removing '/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_postgres-redmine.tar.xz.crypt.sum'...
[Fri Jul 31 01:00:13 UTC 2015] 1696 <== Removing '/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_postgres-redmine.tar.xz.crypt'...
[Fri Jul 31 01:00:13 UTC 2015] 1708 <== Removing '/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_postgres-redmine.tar.xz.key'...
[Fri Jul 31 01:00:13 UTC 2015] 300 <== SUCCESS 1878 <== 'Redmine database' backup completed successfully.
[Fri Jul 31 01:00:13 UTC 2015] 1853 <== Creating a backup from 'ownCloud database'...
[Fri Jul 31 01:00:13 UTC 2015] 1867 <== Dumping 'postgres::owncloud_db' to '/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_postgres-owncloud/postgres-owncloud.sql'...
[Fri Jul 31 01:00:13 UTC 2015] 1463 <== Creating archive '/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_postgres-owncloud.tar.xz'...
[Fri Jul 31 01:00:13 UTC 2015] 1474 <== Removing '2015-07-31_core.babaei.net_postgres-owncloud'...
[Fri Jul 31 01:00:13 UTC 2015] 1493 <== Generating a random passphrase for '/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_postgres-owncloud.tar.xz'...
[Fri Jul 31 01:00:13 UTC 2015] 1542 <== Encrypting '/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_postgres-owncloud.tar.xz'...
[Fri Jul 31 01:00:13 UTC 2015] 1552 <== Removing '/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_postgres-owncloud.tar.xz'...
[Fri Jul 31 01:00:14 UTC 2015] 1562 <== Generating archive checksum '/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_postgres-owncloud.tar.xz.crypt.sum'...
[Fri Jul 31 01:00:14 UTC 2015] 1581 <== SHA512(/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_postgres-owncloud.tar.xz.crypt)= 143e7c0242414dfd56a405ad96ee8261330a73a16d50c27003bb07a610fb4819422791ab40a7acb4d210d650e8ed526d4202f99f6729c2ba441a7b10e25d7f02
[Fri Jul 31 01:00:14 UTC 2015] 1647 <== Uploading 'ownCloud database'...
[Fri Jul 31 01:00:14 UTC 2015] 1268 <== Checking if 'r999@10.17.0.114:203/~/backups/core.babaei.net/postgres-owncloud/2015-07-31' exists...
[Fri Jul 31 01:00:14 UTC 2015] 1275 <== Creating 'r999@10.17.0.114:203/~/backups/core.babaei.net/postgres-owncloud/2015-07-31'
[Fri Jul 31 01:00:14 UTC 2015] 1295 <== Uploading to 'r999@10.17.0.114:203/~/backups/core.babaei.net/postgres-owncloud/2015-07-31'...
[Fri Jul 31 01:00:14 UTC 2015] 1300 <== Uploading '/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_postgres-owncloud.tar.xz.crypt'... ~  16K
[Fri Jul 31 01:00:14 UTC 2015] 1370 <== Uploading '/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_postgres-owncloud.tar.xz.crypt.sum'... ~ 4.0K
[Fri Jul 31 01:00:15 UTC 2015] 1690 <== Removing '/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_postgres-owncloud.tar.xz.crypt.sum'...
[Fri Jul 31 01:00:15 UTC 2015] 1696 <== Removing '/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_postgres-owncloud.tar.xz.crypt'...
[Fri Jul 31 01:00:15 UTC 2015] 1708 <== Removing '/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_postgres-owncloud.tar.xz.key'...
[Fri Jul 31 01:00:15 UTC 2015] 300 <== SUCCESS 1878 <== 'ownCloud database' backup completed successfully.
[Fri Jul 31 01:00:15 UTC 2015] 1853 <== Creating a backup from 'All MySQL databases'...
[Fri Jul 31 01:00:15 UTC 2015] 1867 <== Dumping 'mysql::'*'' to '/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_mysql/mysql.sql'...
[Fri Jul 31 01:00:16 UTC 2015] 1463 <== Creating archive '/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_mysql.tar.xz'...
[Fri Jul 31 01:01:01 UTC 2015] 1474 <== Removing '2015-07-31_core.babaei.net_mysql'...
[Fri Jul 31 01:01:02 UTC 2015] 1493 <== Generating a random passphrase for '/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_mysql.tar.xz'...
[Fri Jul 31 01:01:03 UTC 2015] 1542 <== Encrypting '/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_mysql.tar.xz'...
[Fri Jul 31 01:01:03 UTC 2015] 1552 <== Removing '/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_mysql.tar.xz'...
[Fri Jul 31 01:01:03 UTC 2015] 1562 <== Generating archive checksum '/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_mysql.tar.xz.crypt.sum'...
[Fri Jul 31 01:01:04 UTC 2015] 1581 <== SHA512(/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_mysql.tar.xz.crypt)= 9e7c0f0fb5d4ace5cc6727ed0c1b70ca477b878c75c8fcc8cb42b43ccfe72f497ba3c78304d6767a7802420dab73edcffc19f8ba171a0e33dd696abc28bc5e38
[Fri Jul 31 01:01:04 UTC 2015] 1647 <== Uploading 'All MySQL databases'...
[Fri Jul 31 01:01:04 UTC 2015] 1268 <== Checking if 'r999@10.17.0.114:203/~/backups/core.babaei.net/mysql/2015-07-31' exists...
[Fri Jul 31 01:01:04 UTC 2015] 1275 <== Creating 'r999@10.17.0.114:203/~/backups/core.babaei.net/mysql/2015-07-31'
[Fri Jul 31 01:01:04 UTC 2015] 1295 <== Uploading to 'r999@10.17.0.114:203/~/backups/core.babaei.net/mysql/2015-07-31'...
[Fri Jul 31 01:01:04 UTC 2015] 1300 <== Uploading '/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_mysql.tar.xz.crypt'... ~  11M
[Fri Jul 31 01:01:05 UTC 2015] 1370 <== Uploading '/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_mysql.tar.xz.crypt.sum'... ~ 4.0K
[Fri Jul 31 01:01:05 UTC 2015] 1690 <== Removing '/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_mysql.tar.xz.crypt.sum'...
[Fri Jul 31 01:01:05 UTC 2015] 1696 <== Removing '/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_mysql.tar.xz.crypt'...
[Fri Jul 31 01:01:05 UTC 2015] 1708 <== Removing '/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_mysql.tar.xz.key'...
[Fri Jul 31 01:01:05 UTC 2015] 300 <== SUCCESS 1878 <== 'All MySQL databases' backup completed successfully.
[Fri Jul 31 01:01:05 UTC 2015] 1853 <== Creating a backup from 'Piwik database'...
[Fri Jul 31 01:01:05 UTC 2015] 1867 <== Dumping 'mysql::piwik' to '/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_mysql-piwik/mysql-piwik.sql'...
[Fri Jul 31 01:01:06 UTC 2015] 1463 <== Creating archive '/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_mysql-piwik.tar.xz'...
[Fri Jul 31 01:01:50 UTC 2015] 1474 <== Removing '2015-07-31_core.babaei.net_mysql-piwik'...
[Fri Jul 31 01:01:50 UTC 2015] 1493 <== Generating a random passphrase for '/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_mysql-piwik.tar.xz'...
[Fri Jul 31 01:01:50 UTC 2015] 1542 <== Encrypting '/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_mysql-piwik.tar.xz'...
[Fri Jul 31 01:01:51 UTC 2015] 1552 <== Removing '/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_mysql-piwik.tar.xz'...
[Fri Jul 31 01:01:51 UTC 2015] 1562 <== Generating archive checksum '/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_mysql-piwik.tar.xz.crypt.sum'...
[Fri Jul 31 01:01:51 UTC 2015] 1581 <== SHA512(/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_mysql-piwik.tar.xz.crypt)= aa90141fe55f5543622887ae81c6911e8663af6fbc57ea8336564481c3d261e4e9ce4ee6425936b7f67996cbf4d546b8ab76f92b1301f19ab19167b8a2ce1889
[Fri Jul 31 01:01:51 UTC 2015] 1647 <== Uploading 'Piwik database'...
[Fri Jul 31 01:01:51 UTC 2015] 1268 <== Checking if 'r999@10.17.0.114:203/~/backups/core.babaei.net/mysql-piwik/2015-07-31' exists...
[Fri Jul 31 01:01:51 UTC 2015] 1275 <== Creating 'r999@10.17.0.114:203/~/backups/core.babaei.net/mysql-piwik/2015-07-31'
[Fri Jul 31 01:01:51 UTC 2015] 1295 <== Uploading to 'r999@10.17.0.114:203/~/backups/core.babaei.net/mysql-piwik/2015-07-31'...
[Fri Jul 31 01:01:51 UTC 2015] 1300 <== Uploading '/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_mysql-piwik.tar.xz.crypt'... ~  10M
[Fri Jul 31 01:01:52 UTC 2015] 1370 <== Uploading '/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_mysql-piwik.tar.xz.crypt.sum'... ~ 4.0K
[Fri Jul 31 01:01:52 UTC 2015] 1690 <== Removing '/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_mysql-piwik.tar.xz.crypt.sum'...
[Fri Jul 31 01:01:52 UTC 2015] 1696 <== Removing '/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_mysql-piwik.tar.xz.crypt'...
[Fri Jul 31 01:01:52 UTC 2015] 1708 <== Removing '/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_mysql-piwik.tar.xz.key'...
[Fri Jul 31 01:01:52 UTC 2015] 300 <== SUCCESS 1878 <== 'Piwik database' backup completed successfully.
[Fri Jul 31 01:01:54 UTC 2015] 292 <== INFO 1921 <== All database backup tasks finished.
[Fri Jul 31 01:01:54 UTC 2015] 1955 <== Creating a backup from 'Web server root directory'...
[Fri Jul 31 01:01:54 UTC 2015] 1463 <== Creating archive '/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_www.tar.xz'...
[Fri Jul 31 01:31:02 UTC 2015] 1493 <== Generating a random passphrase for '/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_www.tar.xz'...
[Fri Jul 31 01:31:02 UTC 2015] 1542 <== Encrypting '/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_www.tar.xz'...
[Fri Jul 31 01:31:23 UTC 2015] 1552 <== Removing '/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_www.tar.xz'...
[Fri Jul 31 01:31:23 UTC 2015] 1562 <== Generating archive checksum '/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_www.tar.xz.crypt.sum'...
[Fri Jul 31 01:31:35 UTC 2015] 1581 <== SHA512(/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_www.tar.xz.crypt)= 9c068d61717ac52f48489842d1c04ad52abbbabbe181cd0aa9e1f291c2108eea336a0d8b239a0a37987fddf8868c40869f80e5af5e5d9c79114deb4a3de8d1fc
[Fri Jul 31 01:31:35 UTC 2015] 1647 <== Uploading 'Web server root directory'...
[Fri Jul 31 01:31:35 UTC 2015] 1268 <== Checking if 'r999@10.17.0.114:203/~/backups/core.babaei.net/www/2015-07-31' exists...
[Fri Jul 31 01:31:36 UTC 2015] 1275 <== Creating 'r999@10.17.0.114:203/~/backups/core.babaei.net/www/2015-07-31'
[Fri Jul 31 01:31:36 UTC 2015] 1295 <== Uploading to 'r999@10.17.0.114:203/~/backups/core.babaei.net/www/2015-07-31'...
[Fri Jul 31 01:31:36 UTC 2015] 1300 <== Uploading '/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_www.tar.xz.crypt'... ~ 1.4G
[Fri Jul 31 01:32:19 UTC 2015] 1370 <== Uploading '/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_www.tar.xz.crypt.sum'... ~ 4.0K
[Fri Jul 31 01:32:19 UTC 2015] 1690 <== Removing '/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_www.tar.xz.crypt.sum'...
[Fri Jul 31 01:32:19 UTC 2015] 1696 <== Removing '/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_www.tar.xz.crypt'...
[Fri Jul 31 01:32:19 UTC 2015] 1708 <== Removing '/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_www.tar.xz.key'...
[Fri Jul 31 01:32:19 UTC 2015] 300 <== SUCCESS 1962 <== 'Web server root directory' backup completed successfully.
[Fri Jul 31 01:32:19 UTC 2015] 1955 <== Creating a backup from 'GitLab repositories'...
[Fri Jul 31 01:32:19 UTC 2015] 1463 <== Creating archive '/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_repos.tar.xz'...
[Fri Jul 31 01:52:40 UTC 2015] 1493 <== Generating a random passphrase for '/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_repos.tar.xz'...
[Fri Jul 31 01:52:40 UTC 2015] 1542 <== Encrypting '/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_repos.tar.xz'...
[Fri Jul 31 01:52:55 UTC 2015] 1552 <== Removing '/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_repos.tar.xz'...
[Fri Jul 31 01:52:55 UTC 2015] 1562 <== Generating archive checksum '/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_repos.tar.xz.crypt.sum'...
[Fri Jul 31 01:53:03 UTC 2015] 1581 <== SHA512(/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_repos.tar.xz.crypt)= 88036dac6d9c5d636a7e31ce0b2303f48f41cc9188f31543f3a964107ab4f364756352cd7320c0471fbbb37068cdfdd1ac0d9b56e8902b82b40754de082a3d4a
[Fri Jul 31 01:53:03 UTC 2015] 1647 <== Uploading 'GitLab repositories'...
[Fri Jul 31 01:53:03 UTC 2015] 1268 <== Checking if 'r999@10.17.0.114:203/~/backups/core.babaei.net/repos/2015-07-31' exists...
[Fri Jul 31 01:53:03 UTC 2015] 1275 <== Creating 'r999@10.17.0.114:203/~/backups/core.babaei.net/repos/2015-07-31'
[Fri Jul 31 01:53:03 UTC 2015] 1295 <== Uploading to 'r999@10.17.0.114:203/~/backups/core.babaei.net/repos/2015-07-31'...
[Fri Jul 31 01:53:03 UTC 2015] 1300 <== Uploading '/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_repos.tar.xz.crypt'... ~ 1.1G
[Fri Jul 31 01:53:31 UTC 2015] 1370 <== Uploading '/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_repos.tar.xz.crypt.sum'... ~ 4.0K
[Fri Jul 31 01:53:32 UTC 2015] 1690 <== Removing '/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_repos.tar.xz.crypt.sum'...
[Fri Jul 31 01:53:32 UTC 2015] 1696 <== Removing '/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_repos.tar.xz.crypt'...
[Fri Jul 31 01:53:32 UTC 2015] 1708 <== Removing '/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_repos.tar.xz.key'...
[Fri Jul 31 01:53:32 UTC 2015] 300 <== SUCCESS 1962 <== 'GitLab repositories' backup completed successfully.
[Fri Jul 31 01:53:32 UTC 2015] 1955 <== Creating a backup from 'Mail server root directory'...
[Fri Jul 31 01:53:32 UTC 2015] 1463 <== Creating archive '/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_mail.tar.xz'...
[Fri Jul 31 02:21:44 UTC 2015] 1493 <== Generating a random passphrase for '/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_mail.tar.xz'...
[Fri Jul 31 02:21:44 UTC 2015] 1542 <== Encrypting '/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_mail.tar.xz'...
[Fri Jul 31 02:21:57 UTC 2015] 1552 <== Removing '/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_mail.tar.xz'...
[Fri Jul 31 02:21:57 UTC 2015] 1562 <== Generating archive checksum '/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_mail.tar.xz.crypt.sum'...
[Fri Jul 31 02:22:04 UTC 2015] 1581 <== SHA512(/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_mail.tar.xz.crypt)= 2b28e978f74ff857deb0643fc5f1dbf7b6c50acec3f919cebf672c9038ec365a06a7ddd2c80c5e28b7cecff9b2d659ab9dde4e9ad606d3d7e4d1819284cb19b8
[Fri Jul 31 02:22:04 UTC 2015] 1647 <== Uploading 'Mail server root directory'...
[Fri Jul 31 02:22:04 UTC 2015] 1268 <== Checking if 'r999@10.17.0.114:203/~/backups/core.babaei.net/mail/2015-07-31' exists...
[Fri Jul 31 02:22:05 UTC 2015] 1275 <== Creating 'r999@10.17.0.114:203/~/backups/core.babaei.net/mail/2015-07-31'
[Fri Jul 31 02:22:05 UTC 2015] 1295 <== Uploading to 'r999@10.17.0.114:203/~/backups/core.babaei.net/mail/2015-07-31'...
[Fri Jul 31 02:22:05 UTC 2015] 1300 <== Uploading '/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_mail.tar.xz.crypt'... ~ 1.2G
[Fri Jul 31 02:22:44 UTC 2015] 1370 <== Uploading '/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_mail.tar.xz.crypt.sum'... ~ 4.0K
[Fri Jul 31 02:22:44 UTC 2015] 1690 <== Removing '/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_mail.tar.xz.crypt.sum'...
[Fri Jul 31 02:22:44 UTC 2015] 1696 <== Removing '/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_mail.tar.xz.crypt'...
[Fri Jul 31 02:22:44 UTC 2015] 1708 <== Removing '/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_mail.tar.xz.key'...
[Fri Jul 31 02:22:44 UTC 2015] 300 <== SUCCESS 1962 <== 'Mail server root directory' backup completed successfully.
[Fri Jul 31 02:22:44 UTC 2015] 1955 <== Creating a backup from 'Base system configurations'...
[Fri Jul 31 02:22:44 UTC 2015] 1463 <== Creating archive '/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_etc-system.tar.xz'...
[Fri Jul 31 02:22:47 UTC 2015] 1493 <== Generating a random passphrase for '/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_etc-system.tar.xz'...
[Fri Jul 31 02:22:48 UTC 2015] 1542 <== Encrypting '/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_etc-system.tar.xz'...
[Fri Jul 31 02:22:48 UTC 2015] 1552 <== Removing '/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_etc-system.tar.xz'...
[Fri Jul 31 02:22:48 UTC 2015] 1562 <== Generating archive checksum '/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_etc-system.tar.xz.crypt.sum'...
[Fri Jul 31 02:22:48 UTC 2015] 1581 <== SHA512(/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_etc-system.tar.xz.crypt)= bdfca0fb8bad158780368589da43b0ccc86bfc6f7aa089f615714eb09308854328b9ae8699c267688b50e2fd99aee8fcc1d43054488beae3b1410769f2858422
[Fri Jul 31 02:22:48 UTC 2015] 1647 <== Uploading 'Base system configurations'...
[Fri Jul 31 02:22:48 UTC 2015] 1268 <== Checking if 'r999@10.17.0.114:203/~/backups/core.babaei.net/etc-system/2015-07-31' exists...
[Fri Jul 31 02:22:48 UTC 2015] 1275 <== Creating 'r999@10.17.0.114:203/~/backups/core.babaei.net/etc-system/2015-07-31'
[Fri Jul 31 02:22:48 UTC 2015] 1295 <== Uploading to 'r999@10.17.0.114:203/~/backups/core.babaei.net/etc-system/2015-07-31'...
[Fri Jul 31 02:22:48 UTC 2015] 1300 <== Uploading '/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_etc-system.tar.xz.crypt'... ~ 304K
[Fri Jul 31 02:22:49 UTC 2015] 1370 <== Uploading '/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_etc-system.tar.xz.crypt.sum'... ~ 4.0K
[Fri Jul 31 02:22:49 UTC 2015] 1690 <== Removing '/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_etc-system.tar.xz.crypt.sum'...
[Fri Jul 31 02:22:49 UTC 2015] 1696 <== Removing '/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_etc-system.tar.xz.crypt'...
[Fri Jul 31 02:22:49 UTC 2015] 1708 <== Removing '/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_etc-system.tar.xz.key'...
[Fri Jul 31 02:22:49 UTC 2015] 300 <== SUCCESS 1962 <== 'Base system configurations' backup completed successfully.
[Fri Jul 31 02:22:49 UTC 2015] 1955 <== Creating a backup from 'Installed ports configurations'...
[Fri Jul 31 02:22:49 UTC 2015] 1463 <== Creating archive '/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_etc-ports.tar.xz'...
[Fri Jul 31 02:22:53 UTC 2015] 1493 <== Generating a random passphrase for '/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_etc-ports.tar.xz'...
[Fri Jul 31 02:22:53 UTC 2015] 1542 <== Encrypting '/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_etc-ports.tar.xz'...
[Fri Jul 31 02:22:53 UTC 2015] 1552 <== Removing '/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_etc-ports.tar.xz'...
[Fri Jul 31 02:22:53 UTC 2015] 1562 <== Generating archive checksum '/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_etc-ports.tar.xz.crypt.sum'...
[Fri Jul 31 02:22:53 UTC 2015] 1581 <== SHA512(/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_etc-ports.tar.xz.crypt)= 0df1727a77395ae4346fd9f257451fd9976bc6a2933c209c8daf8aa655834a6f6c472764d067703c954f4963ee2f0f4b585c565de48f4c42aa216204971c7b2e
[Fri Jul 31 02:22:53 UTC 2015] 1647 <== Uploading 'Installed ports configurations'...
[Fri Jul 31 02:22:53 UTC 2015] 1268 <== Checking if 'r999@10.17.0.114:203/~/backups/core.babaei.net/etc-ports/2015-07-31' exists...
[Fri Jul 31 02:22:53 UTC 2015] 1275 <== Creating 'r999@10.17.0.114:203/~/backups/core.babaei.net/etc-ports/2015-07-31'
[Fri Jul 31 02:22:54 UTC 2015] 1295 <== Uploading to 'r999@10.17.0.114:203/~/backups/core.babaei.net/etc-ports/2015-07-31'...
[Fri Jul 31 02:22:54 UTC 2015] 1300 <== Uploading '/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_etc-ports.tar.xz.crypt'... ~ 640K
[Fri Jul 31 02:22:54 UTC 2015] 1370 <== Uploading '/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_etc-ports.tar.xz.crypt.sum'... ~ 4.0K
[Fri Jul 31 02:22:54 UTC 2015] 1690 <== Removing '/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_etc-ports.tar.xz.crypt.sum'...
[Fri Jul 31 02:22:54 UTC 2015] 1696 <== Removing '/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_etc-ports.tar.xz.crypt'...
[Fri Jul 31 02:22:54 UTC 2015] 1708 <== Removing '/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_etc-ports.tar.xz.key'...
[Fri Jul 31 02:22:54 UTC 2015] 300 <== SUCCESS 1962 <== 'Installed ports configurations' backup completed successfully.
[Fri Jul 31 02:22:54 UTC 2015] 1955 <== Creating a backup from 'System bootstrap configuration information'...
[Fri Jul 31 02:22:54 UTC 2015] 1463 <== Creating archive '/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_loader-conf.tar.xz'...
[Fri Jul 31 02:22:54 UTC 2015] 1493 <== Generating a random passphrase for '/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_loader-conf.tar.xz'...
[Fri Jul 31 02:22:54 UTC 2015] 1542 <== Encrypting '/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_loader-conf.tar.xz'...
[Fri Jul 31 02:22:54 UTC 2015] 1552 <== Removing '/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_loader-conf.tar.xz'...
[Fri Jul 31 02:22:54 UTC 2015] 1562 <== Generating archive checksum '/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_loader-conf.tar.xz.crypt.sum'...
[Fri Jul 31 02:22:54 UTC 2015] 1581 <== SHA512(/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_loader-conf.tar.xz.crypt)= d6900b1cb7cd3277eb15d5c80c01dd7b937fd002d66d4c0d1b0e40acfcc90acffc8a3c41a73761c21574b79fed0e8e904e59d71ea512e928cb3079ab75aa7e7c
[Fri Jul 31 02:22:55 UTC 2015] 1647 <== Uploading 'System bootstrap configuration information'...
[Fri Jul 31 02:22:55 UTC 2015] 1268 <== Checking if 'r999@10.17.0.114:203/~/backups/core.babaei.net/loader-conf/2015-07-31' exists...
[Fri Jul 31 02:22:55 UTC 2015] 1275 <== Creating 'r999@10.17.0.114:203/~/backups/core.babaei.net/loader-conf/2015-07-31'
[Fri Jul 31 02:22:55 UTC 2015] 1295 <== Uploading to 'r999@10.17.0.114:203/~/backups/core.babaei.net/loader-conf/2015-07-31'...
[Fri Jul 31 02:22:55 UTC 2015] 1300 <== Uploading '/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_loader-conf.tar.xz.crypt'... ~ 4.0K
[Fri Jul 31 02:22:55 UTC 2015] 1370 <== Uploading '/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_loader-conf.tar.xz.crypt.sum'... ~ 4.0K
[Fri Jul 31 02:22:56 UTC 2015] 1690 <== Removing '/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_loader-conf.tar.xz.crypt.sum'...
[Fri Jul 31 02:22:56 UTC 2015] 1696 <== Removing '/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_loader-conf.tar.xz.crypt'...
[Fri Jul 31 02:22:56 UTC 2015] 1708 <== Removing '/var/tmp/backup.2015-07-31.58471/2015-07-31_core.babaei.net_loader-conf.tar.xz.key'...
[Fri Jul 31 02:22:56 UTC 2015] 300 <== SUCCESS 1962 <== 'System bootstrap configuration information' backup completed successfully.
[Fri Jul 31 02:22:56 UTC 2015] 292 <== INFO 3141 <== All backup tasks finished.
[Fri Jul 31 02:22:56 UTC 2015] 3159 <== Cleaning up '/var/tmp/backup.2015-07-31.58471'...
[Fri Jul 31 02:22:56 UTC 2015] 3218 <== It took 1h 22m 56s to finish all backup tasks.
[Fri Jul 31 02:22:56 UTC 2015] 292 <== INFO 3219 <== All backups by OmniBackup v0.1.0.

Have question or need technical assistance, please visit http://www.babaei.net/ or write an email to info [ at ] babaei.net.


[2015-07-31_core.babaei.net_postgres.tar.xz.crypt](sY1JCw8va0sYESubH55MG81CIH0HmvMbXakquBGdXvCMKtP6bSmMSlSWLOPQqWHUGnIoyeFjUmZXB6dPn7w9qxrB6MHDuCTz7MLOq3PiS9FH1bzL6kVqkMgcskeJduZY)
[2015-07-31_core.babaei.net_postgres-gitlab.tar.xz.crypt](COKeMtmQevwbU7y9lz96OCzFYjaxnzfXEjoTUCHvAYHBWLV8obluJvwuK4afEkOdPs9vIyuHkx4lgePYdyAejIN5JYffiwQBKtbQYRohhZ39ejYrnbppXBsvQjRbF8up)
[2015-07-31_core.babaei.net_postgres-redmine.tar.xz.crypt](C4oLIMxFBXjLGUjCQ1I4xQGJhLE7pIM8HWtvJOhkR9TNJn3CcadmWpYSp6pbZZCmLs5tMbJ9QQhwB3c1H8GIPzWJLop3bm49c55K7ynrTEj4GW2KjlhozwvNdTps0sJ0)
[2015-07-31_core.babaei.net_postgres-owncloud.tar.xz.crypt](HIKxwvSuk6wIHlRjRchxtT6OxIMdzfiRVehCbrK3QsS8SC6jLXxE1BP2zssVMq5IWpCtRrp89plkxIdKLBLhjC3hKyA7Wo0lc9oZs2nqYob2ofCqWS8IkgRBAaGKJdaj)
[2015-07-31_core.babaei.net_mysql.tar.xz.crypt](hxISUfxgJc49IMr7Z75vlEO71Gy7ZR6bRPNPbRU32UpAIzTzlYm94sefQOgmkv4L7kYMU5e4xN48hhnqZPj9no4UnMgy5C1LdGsm3TPKYUv8Ogzc2h77gPdCcjxjI5Ds)
[2015-07-31_core.babaei.net_mysql-piwik.tar.xz.crypt](QkAtura4wHJ95RHutBgaaFKwWqIvqjswTsfL8vz7HlFpjXLOUeJRaAT6uKDBiOccaggFWD7cru845GLxfYpa4wVTWLUXaUbmB5UyeQ0Jt99qDVvDivLfXUN7EVOIjlD4)
[2015-07-31_core.babaei.net_www.tar.xz.crypt](ciaLyhXnJj9KRiXVsJhEOTt8slxbEYoGRwq9GHuL6nKXZm6rHqA9ySNRe1uwFpGUNVbx7hatcWUFxAC4Wfzzh8OOH8lj4ND7p4T9N3B6pG1Jn6sG3o4EKhYPw75WyRgY)
[2015-07-31_core.babaei.net_repos.tar.xz.crypt](vvEYkJr4KvjalYPIwPs9TRm7UOmqOeLBPVzk02Djov718PoVooVtM5YcsSWqwVort10LK8EY6Q2thCPWCoUnCV6TfznewYW1DZ3OwPqhVWNNdaARvXpdpKmF5nkdxtgV)
[2015-07-31_core.babaei.net_mail.tar.xz.crypt](EBNcWoyZy3kH2fr8YpjW5IIZzFfTMU0EanLXyr0fvObcXb4h3xap2j710YWYkFL5pYliy9BylRMqDBRtDBv6zKXoQsdiiqbvdd79YAIW50DZNCmuJ3hTDi3hYbMsRJpm)
[2015-07-31_core.babaei.net_etc-system.tar.xz.crypt](Qs2aqAPFmsLJ3hz0dB01NzKj3zCV33sXUH39u4YZudfQquXg9q9UeAtQtEzIHUG6alWIG67ANHbEZug8l7E5D55Sv4If81vKnyj2HU1Qrv31GFfxg2IWhCDovSuJloJR)
[2015-07-31_core.babaei.net_etc-ports.tar.xz.crypt](z8SfpAvMsI2efM56WNs3PrxIS9CB1ITD8bB5FMYPyVKqysWTChR3PoMbIjUzNBp02PsX3hJn1Ws7OyZ02UEeqaUMavuOLzeCQDJXnUOYnmUfqzJTE07Hiw3GpkPaJzxb)
[2015-07-31_core.babaei.net_loader-conf.tar.xz.crypt](nGedoAb7kTnlu9gApBX1vurtalU6SEWq8SZ0KweKoLCSG7QUZzDWVUY4PHbIRiahOP3008Gmg4NtpeAOKzohjwgLqQ9vXCLNAcBVqgIYMiDRILsLZ7X81E7WaI3zGkWp)
```


<br />
<a name="ToDo"></a>

### ToDo

There is also a list of planned features and TODOs which did not make it into <code>0.1.x</code> release:

* Restore script
* GnuPG integration
* SFTP and FTP support
* Refactoring and code clean-up
* Any potential bug fixes


<br />
<a name="License"></a>

### License

(The MIT License)

Copyright (c) 2015 - 2019 Mamadou Babaei

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the ‘Software’), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED ‘AS IS’, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.



