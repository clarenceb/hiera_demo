require 'rubygems'
require 'hiera'
require 'facter'

hiera = Hiera.new(:config => "hiera.yaml")

# Look up a non-existent key: fallback to default value "not found".
puts hiera.lookup("madeup", "not found", { })

# No scope provided: fallback to `common` in hierachy.
puts hiera.lookup("magic_word", "", { })

# Lookup values with specified facts.
# Note: Here we use Facter but we can also load a YAML or JSON file
# and use facts from those.
puts hiera.lookup("magic_word", "", { 'fqdn' => Facter::fqdn})
