#!/bin/sh

GNUPGHOME=`pwd`/.gnupg
gpg --homedir $GNUPGHOME $*
