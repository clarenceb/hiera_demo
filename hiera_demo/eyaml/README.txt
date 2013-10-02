#############################
# HIERA - EYAML DEMO
#############################

# See the file/directory structure for this demo:

$ tree .
.
├── data
│   ├── common.yaml
│   ├── hierademo.example.com.yaml
│   ├── secret.eyaml
│   └── _secret.yaml
├── hiera.yaml
├── keys
│   ├── private_key.pkcs7.pem
│   └── public_key.pkcs7.pem
├── papply.sh
└── README.txt

# Install hiera-eyaml gem
sudo gem install hiera-eyaml

# Generate key pairs: default uses PKCS7
# (currently a bug on 32-bit linux, pkcs7.rb:72) - due to not_after being too
# large).
eyaml -c

# See the key files that were generated.
ls -1 keys
private_key.pkcs7.pem
public_key.pkcs7.pem145831

# Put some text you want to encrypt into a file (e.g. a password)
echo "This is the secret I want to encrypt" > input.txt 

# Then encrypt it, generating a key and value (encrypted).
eyaml -e -l "top_secret" -o string -f input.txt > output.eyaml

# It looks like this...
cat output.eyaml

top_secret: ENC[PKCS7,MIIBmQYJKoZIhvcNAQcDoIIBijCCAYYCAQAxggEhMIIBHQIBADAFMAACAQAwDQYJKoZIhvcNAQEBBQAEggEARUTCgZRrS57cWjJrLywq8GYEC6yf1f4u+YXH7lwDKo9QcmzdhrbcNVPcTrRBk7GsZO6oVgVspOW+lJkjNfRqSIuE3kMUc+/OV/C3BiE6r3k6LErVVj4+THf7NTAWZGWX2GAzdvn1YPyGqW6PIEiWeWyB4uBcq4q3o/CSCYJeusYjCI7I068CGus1F3ktkbU4lFmk6RDFsBU6CK2hox6gmS52ycUL8FgXKOqFfFX2mcs9jAS4jGrgabMGI+P/AuSnHpQjIHrSdA/8Lvx0TMUc3+2b6t1UoYtAee7KCsnLlX7D6XkNVrY/c6s+QyiqarInEe0yxBIMN8mb8bwD3xGQIDBcBgkqhkiG9w0BBwEwHQYJYIZIAWUDBAEqBBDVueZghHja9iKhItku9UjqgDDMMAmfxPl6Qg29Bh1Rk5FIYq1RK8VI6qHcxqUidTkFZjpW83SXWXP/JP3yJZpU1Vk=]

# Test decrypting the file.
eyaml -d -f output.eyaml
# Output:
top_secret: This is the secret I want to encrypt

# Copy the key-value encrypted pairs to yout data/secrets.eyaml file (or whatever its
# called)
cp output.eyaml data/secret.eyaml

# Test it out with `hiera` command:

hiera -c hiera.yaml top_secret
hiera -c hiera.yaml top_secret --debug

# And finally, a `puppet apply` run:
sudo ./papply.sh
sudo ./papply.sh --debug

# Issues:
# --------------------------------------------
# 1. -i doesn't seem to work - leaves file unencrypted
# 2. -o block doesn't seem to work proeprly - the file can't be descrypted
# with the key value in the the file.
# 3. -s option for encrypting string doesn't seem to work (only decrypts
# string up to first space).
# 4. `eyaml -c` fails on 32-bit linux (there is a work around)

