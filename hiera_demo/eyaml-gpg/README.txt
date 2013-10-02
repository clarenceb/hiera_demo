#############################
# HIERA - EYAML-GPG DEMO
#############################

# See the file/directory structure for this demo:

$ tree -a .
.
├── data
│   ├── common.yaml
│   ├── hierademo.example.com.yaml
│   └── secret.eyaml
├── .gnupg
│   ├── gpg.conf
│   ├── pubring.gpg
│   ├── random_seed
│   ├── secring.gpg
│   └── trustdb.gpg
├── hiera-eyaml-gpg.recipients
├── hiera.yaml
├── input.txt
├── keyring
│   ├── pubring.gpg
│   ├── random_seed
│   ├── secring.gpg
│   └── trustdb.gpg
├── keys
│   ├── private_key.pkcs7.pem
│   └── public_key.pkcs7.pem
├── papply.sh
├── README.txt

# Install gem
sudo gem install hiera-eyaml-gpg

# This demo is very similar to the eyaml one but we add support for GPG
# encryption/decryption.

# Take a look at hiera.yaml.
# New bit it the :gpg_gnupghome: section so eyaml knows where to find the
# keyring for decrypting data.

# NOTE: Potential problem exists with hiera-gpg reading command line args???
# .e.g --gpg-recipients and --gnuphhome
# Workaround: copy .gnupg to your HOME dir and then eyaml-gpg will pick up the
# keyring from there.
cp -a .gnupng ~
echo "puppet@dv.example.com" > hiera-eyaml-gpg.recipient

# Encrypt some data in eyaml format but with GPG encryption.
echo "This is the secret I want to encrypt" > input.txt 
eyaml -n gpg -o string -l "top_secret" -e -f input.txt > output.eyaml

# See the encrypted file:
# Note: ENC[GPG,...]
cat output.eyaml
top_secret: ENC[GPG,hIwDDXibqULn1w4BBACR5XGqNJvfk7rOz8u1lq/W7f/sFTxwM4mFbrAKkBXEOQnExia3a70kGxUctDe8eNL3uxLBnbCCtPa3/4YEWagLfcml4p+k2+wXK3lmaQSH/p2z3eooS90niqYOzyF2T0yw/mgt/5gyaYjLOuRteQTYSSBoiilKmhZpgAjaD47lrtJhAQSLNm1a0Qpm16OYLrJxI0Iv6RCosufrLtFNTZJXMkc0FQgzfocw8jWnpwjrHH6ZE4M7qB1jXBuOxRVoyxjbAjleT0FUJhV7/7Mnru6iLCyZpIanspNVS++XsDPEIt6MHA==]

# Add this output to the data/secret.eyaml from the `eyaml` demo.
# Rename the PCKS7 secret to `other_secret`.

# Test decryption
eyaml -d -f output.eyaml
# Output:
top_secret: This is the secret I want to encrypt
other_secret: This is the secret I want to encrypt

# Note: you can mix plain values, pkcs7 encrypted values and GPG encrypted
# values in the same eyaml file.

# Test it out with `hiera` command:

hiera -c hiera.yaml top_secret
hiera -c hiera.yaml top_secret --debug

# And finally, a `puppet apply` run:
sudo ./papply.sh
sudo ./papply.sh --debug

# Advantages are that its easier to see what's in the config (not opaque).
# Anyone can update the config - but only those with the secret key can
# decrypt values.

