#############################
# HIERA - GPG DEMO
#############################

# See the file/directory structure for this demo:

$ tree -a .
.
├── .gnupg
│   ├── gpg.conf
│   ├── pubring.gpg
│   ├── random_seed
│   ├── secring.gpg
│   └── trustdb.gpg
├── README.txt
├── data
│   ├── _secret.yaml
│   ├── common.yaml
│   ├── hierademo.example.com.yaml
│   └── secret.gpg
├── gpg.sh
├── hiera.yaml
├── keyring
│   ├── pubring.gpg
│   ├── random_seed
│   ├── secring.gpg
│   └── trustdb.gpg
├── papply.sh
├── puppetmaster_dev.pubkey.txt

# Create a GPG keyring for each puppetmaster.
#
# Note: You can skip this step as the GPG keys are already generated as part
# of the demo repo.
#
# Tip: Export the public keys for each puppet master and developer to a central
#      keyring and put it in VCS.
#      Keep dev and prod keyrings separate (for security reasons and to ensure we
#      don't accidently use the wrong public key(s)). 
#
# Note: Currently hiera-gpg gem doesn’t support key passphrases.

# 1. Create GPG public and secret key
#    (use gpg.sh to store keyring locally rather than in user's home dir)

./gpg.sh --gen-key

# Example options:
# (4) RSA (sign only)
# 1024
# 0
# y
# Real name: Puppet Master (Dev) 
# Email address: puppet@dev.example.com
# Comment: Development
# o
# Enter passphrase: <blank>

./gpg.sh --list-keys
/vagrant/hiera_demo/gpg/.gnupg/pubring.gpg
-----------------------------------------------------------------------------
pub   1024R/488F9A00 2013-10-02
uid                  Puppet Master (Dev) (Development) <puppet@dev.example.com>

# This is the master secret key and can only be used for signing or revoking
# subkeys.

# Add a subkey to be able to encrypt data.

./gpg.sh --edit-key puppet@dev.example.com

Command> addkey

# (6) RSA (encrypt only)
# 1024
# 0
# y
# y
# quit
# y

./gpg.sh --list-keys

/vagrant/hiera_demo/gpg/.gnupg/pubring.gpg
-----------------------------------------------------------------------------
pub   1024R/488F9A00 2013-10-02
uid                  Puppet Master (Dev) (Development) <puppet@dev.example.com>
sub   1024R/42E7D70E 2013-10-02

# Now we can see the sub key.

# List the secret keys.

./gpg.sh --list-secret-keys
/vagrant/hiera_demo/gpg/.gnupg/secring.gpg
------------------------------------------
sec   1024R/488F9A00 2013-10-02
uid                  Puppet Master (Dev) (Development) <puppet@dev.example.com>
ssb   1024R/42E7D70E 2013-10-02

# Export the public key (of the subkey) for the puppet master so that devs/ops can use
# it for encrypting data.

./gpg.sh --armor --export 42E7D70E > puppetmaster_dev.pubkey.txt

# Import the public key into s shared keyring under VCS.
# This could be a git repo checked out locally, for example.

mkdir keyring
chmod 700 keyring

# No keys yet...
gpg --homedir=keyring --list-keys
gpg --homedir=keyring --list-secret-keys

# Import the public key to this new keyring.
gpg --import --homedir=keyring puppetmaster_dev.pubkey.txt
# Output:
gpg: keyring `keyring/secring.gpg' created
gpg: key 488F9A00: public key "Puppet Master (Dev) (Development) <puppet@dev.example.com>" imported
gpg: Total number processed: 1
gpg:               imported: 1  (RSA: 1)

gpg --homedir=keyring --list-secret-keys
# No secret keys in there (as we expected)

gpg --homedir=keyring --list-keys
# Output:
keyring/pubring.gpg
-------------------
pub   1024R/488F9A00 2013-10-02
uid                  Puppet Master (Dev) (Development) <puppet@dev.example.com>
sub   1024R/42E7D70E 2013-10-03

# Create data/_secret.yaml file with top_secret key:
# (use leading underscore so that the yaml backend ignores it)
top_secret: 'This is encrypted: For your eyes only.'

# Now take a look at hiera.yaml which has been updated to use the gpg backend
# `gpg` backend should come first
# :gpg: section has :key_dir: which points to our gpg keyring with secret key inside.
# This would be deployed to each puppet master node.
# Tip: Remove your master key from the keyring before distributing it to each puppet
#      master.

# Encrypt the secret file (normally you would then remove original):
./gpg.sh --trust-model=always --homedir=keyring --encrypt -o data/secret.gpg -r puppet@dev.example.com data/_secret.yaml

# Try to decrypt the file directly.
# We use the secret key from .gnupg directly since keyring only holds the private key.
./gpg.sh --decrypt data/secret.gpg

# Install hiera-gpg gem
sudo gem install hiera-gpg

# Test it out via `hiera` command:
hiera -c hiera.yaml top_secret
hiera -c hiera.yaml top_secret --debug

# Test it out via a `puppet apply` run.
./papply.sh
./papply.sh --debug

# Notes:
#  - You can encrypt data for multiple recipients:
#     e.g. puppet master + some admins, etc.
#  - Keep master secret keys in an encrypted parition (LUKS) or file (e.g. TrueCrypt).
#
## Issues:
# - How to do updates to secret.gpg?
#   (whole file is encrypted - where do we keep unencrypted version?)
#   see:  http://slashdevslashrandom.wordpress.com/2013/06/03/my-griefs-with-hiera-gpg/
#   Could just decrypt whole file...but if we want anyone to update the file we
#   might want to use eYaml/eYaml-gpg

