#############################
# Hiera Demo
#############################

Mini demos:

1. simple       - basic hiera usage from puppet
2. ruby-example - using hiera from ruby code without puppet
3. complex      - more advanced hierachies with hiera from puppet
4. gpg          - encrypting hiera data files with hiera-gpg gem
5. eyaml        - mix encrypted and plain values
6. eyaml-gpg    - use eyaml with gpg encryption backend

Other directories:

puppet            - puppet files for demo (manifests, mnodules)
eyaml/keys        - PKCS7 keys (public/private) generated by hiera-eyaml gem
gpg/keyring       - GPG keyring for puppet to use when decrypting
gpg/.gnupg        - Master GPG keyring (export puppet's keys from here to `keyring` directory) 
eyaml-gpg/.gnupg  - Master GPG keyring (export puppet's keys from here to `keyring` directory)
