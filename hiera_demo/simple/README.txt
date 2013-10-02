#############################
# HIERA - SIMPLE DEMO
#############################

# See the file/directory structure for this demo:

$ tree .
.
├── data
│   ├── common.yaml
│   └── hierademo.example.com.yaml
├── hiera.yaml
├── papply.sh
└── README.txt

# See that hiera works and returns values.
sudo ./papply.sh

# See how hiera resolves values in hierachy in debug mode.
sudo ./papply.sh --debug

# See that four users were created (3 from common and 1 from %{fqdn}) 
sudo puppet resource user edward
sudo puppet resource user david 
sudo puppet resource user joe 
sudo puppet resource user franklin 

# We can test out hiera from commandline with `hiera` command - useful for debugging or simulating other nodes
hiera -c hiera.yaml magic_word
hiera -c hiera.yaml magic_word fqdn=`hostname`

# Observe array and hash values: `users_array` and `settings_hash`
# in the puppet apply output (try with --debug).
# (see modules/hello/manifests/init.pp)

sudo ./papply.sh
sudo ./papply.sh --debug

hiera -c hiera.yaml users_array -a
hiera -c hiera.yaml users_array fqdn=`hostname` -a

# Hash values are easier to see with `hiera` than `papply.sh`.
hiera -c hiera.yaml settings_hash -h
hiera -c hiera.yaml settings_hash fqdn=`hostname` -h

