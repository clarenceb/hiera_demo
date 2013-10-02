###################
# HIERA - RUBY DEMO
###################

# See the file/directory structure for this demo:

$ tree .
.
├── data
│   ├── common.yaml
│   └── hierademo.example.com.yaml
├── hiera-ruby.rb
├── hiera-ruby.sh
├── hiera.yaml
└── README.txt

# See how hiera can be used from your ruby code without puppet.
./hiera-ruby.sh

# or

ruby hiera-ruby.rb

