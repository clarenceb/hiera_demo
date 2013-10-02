#############################
# HIERA - COMPLEX DEMO
#############################

# The main thing in this demo is to observe the values for key 'magic_word'.

# See the file/directory structure for this demo:

$ tree .
.
│   ├── common.yaml
│   ├── dev
│   │   ├── hello.yaml
│   │   ├── melbourne
│   │   └── sydney
│   ├── prod
│   │   ├── hello.yaml
│   │   ├── melbourne
│   │   └── sydney
│   │       └── hello.yaml
│   └── staging
│       ├── hello.yaml
│       ├── melbourne
│       └── sydney
├── hiera.yaml
├── papply.sh
└── README.txt

# Slightly more complex hierachy (env, location, calling_module, common)
sudo ./papply.sh --debug

# Passing facts to hiera (env)
sudo FACTER_env=dev ./papply.sh
sudo FACTER_env=prod ./papply.sh

# Passing more facts to hiera (env + location)
sudo FACTER_env=prod FACTER_location=sydney ./papply.sh

# Show available facts via facter gem
facter
facter hostname
facter fqdn

# You can define your own custom facts (static or dynamic via code) in other
# ways.  Not covered in this demo.

