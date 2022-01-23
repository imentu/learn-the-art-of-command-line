## man

用于搜索和查看参考手册的命令。

### 概念

#### section

一个手册可能有多个章节，以数字 1-9 区分，数字与章节内容对应关系如下：

1. Executable programs or shell commands
2. System calls (functions provided by the kernel)
3. Library calls (functions within program libraries)
4. Special files (usually found in /dev)
5. File formats and conventions, e.g. /etc/passwd
6. Games
7. Miscellaneous（杂项） (including macro packages and conventions), e.g. man(7), groff(7)
8. System administration commands (usually only for root)
9. Kernel routines [Non standard]

如果不指定要查看的章节号，man 会以预定义的顺序搜索并打开第一个匹配的章节，即使对应手册可能有多个章节。

例如：man 有 1 和 7 两个章节，如果不指定章节号，默认打开 man(1)。

```shell
$man -f man
man (7)              - macros to format man pages
man (1)              - an interface to the system reference manuals
```

#### pager

man 使用 pager 显示手册内容，可以通过 `-P` 参数或者 `$MANPGER` 变量指定你需要的 pager。

##### 使用 nvim 作为 pager

每次使用 man 指定 `-P` 参数：

```
man -P "nvim -c 'set ft=man' -" ls
```

或者设定 `$MANPAGER` 环境变量： 

```
export PAGER="nvim -u NORC -c 'set ft=man' -"
```

### 使用方式

```shell
$man ls
```

#### 显示摘要（whatis）

以 `name(section number) short descriptions` 的格式打印手册信息，等价于 `man -f passwd` 。

```shell
$whatis passwd
passwd (5)           - the password file
passwd (1ssl)        - compute password hashes
passwd (1)           - change user password
$man -f passwd
passwd (5)           - the password file
passwd (1ssl)        - compute password hashes
passwd (1)           - change user password
```

#### 指定章节号

```shell
$man 7 man
$man man.7
$man 'man(7)' # 需要用引号包裹防止语法与 shell 冲突
```

#### 显示所有章节

```shell
$man -a man # 拼接所有章节显示（退出显示上一章节时会提示是否继续显示其它章节）
--Man-- next: man(7) [ view (return) | skip (Ctrl-D) | quit (Ctrl-C) ]
```

#### 搜索

##### 参数

`-i` ：不区分大小写，默认选项。

`-I` ：区分大小写。

`--regex` ：使用正则表达式匹配。

`--names-only` ：仅匹配名称字段。

`--no-subpages` ：不连接参数（查询子命令），默认情况下，man 会用中划线或下划线连接所有参数用来匹配子命令。例如：`man git add` = `man git-add` 。

##### 名称和描述（apropos）

根据参数搜索手册的 name 和 short descriptions 字段并以 `name(section number) short descriptions` 的格式打印匹配项的信息，支持正则表达式。等价于 `man -k passwd` 。

```shell
$apropos passwd
chgpasswd (8)        - update group passwords in batch mode
chpasswd (8)         - update passwords in batch mode
gpasswd (1)          - administer /etc/group and /etc/gshadow
grub-mkpasswd-pbkdf2 (1) - generate hashed password for GRUB
openssl-passwd (1ssl) - compute password hashes
pam_localuser (8)    - require users to be listed in /etc/passwd
passwd (1)           - change user password
passwd (1ssl)        - compute password hashes
passwd (5)           - the password file
update-passwd (8)    - safely update /etc/passwd, /etc/shadow and /etc/group
$man -k passwd
chgpasswd (8)        - update group passwords in batch mode
chpasswd (8)         - update passwords in batch mode
gpasswd (1)          - administer /etc/group and /etc/gshadow
grub-mkpasswd-pbkdf2 (1) - generate hashed password for GRUB
openssl-passwd (1ssl) - compute password hashes
pam_localuser (8)    - require users to be listed in /etc/passwd
passwd (1)           - change user password
passwd (1ssl)        - compute password hashes
passwd (5)           - the password file
update-passwd (8)    - safely update /etc/passwd, /etc/shadow and /etc/group
```

##### 全文检索

全文搜索所有手册，默认打开匹配项，指定 `-w` 参数后只显示手册路径。

```shell
$man -Kw VPN
/usr/share/man/man1/ssh.1.gz
/usr/share/man/man1/ssh.1.gz
/usr/share/man/man1/ssh.1.gz
/usr/share/man/man1/ssh.1.gz
/usr/share/man/man1/systemd-ask-password.1.gz
/usr/share/man/man8/ip-netns.8.gz
/usr/share/man/man8/networkd-dispatcher.8.gz
/usr/share/man/man5/netplan.5.gz
/usr/share/man/man5/systemd.netdev.5.gz
```

## type

Bash 中的命令有两种：可执行程序和内置命令。

使用 `type command` 可以查看命令的类型。

type 命令还可以分辨出 alias,keyword,function 类型的参数。

## help

man 无法查看 Bash 内置命令的手册，可以使用 help 命令查看 Bash 内置命令的帮助。

### 使用方式

#### 显示摘要

等价于 `man -f command` 。

```shell
$help -d cd
cd - Change the shell working directory.
```

#### 显示语法

```shell
$help -s cd
cd: cd [-L|[-P [-e]] [-@]] [dir]
```

#### 详细手册（伪装 man）

```shell
help -m cd
```