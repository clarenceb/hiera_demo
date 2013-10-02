hiera demo
==========

A series of mini demos that show how you can use `hiera` to manage
application config external to your ruby app code or puppet manifests.

Also shows how to use GPG or PCKS7 to encrypt configuration.

See hiera_demo/README.txt for further info.

Prerequisities:
---------------
* vagrant 1.2.x
** Virtual 4.2.x (for Vagrant)
* Ruby (Tested with ruby 1.9.3p448) 

Steps:
------
* Start the VM with `vagrant up`
* `cd \vagrant\hiera_demo`
* Read `README.txt`
* Each subdirectory has a `README.txt` with individual demo steps.

Further Reading on Hiera:
-------------------------
* [Why Hiera?](http://docs.puppetlabs.com/hiera/1/index.html)
* [Hiera Complete Example](http://docs.puppetlabs.com/hiera/1/complete_example.html)
* [The hiera.yaml Config file](http://docs.puppetlabs.com/hiera/1/configuring.html)
* [hiera-mysql backend](http://www.craigdunn.org/2012/03/introducing-hiera-mysql-mysql-backend-for-hiera/)
* [hiera-http backend](http://www.craigdunn.org/2012/11/puppet-data-from-couchdb-using-hiera-http/)

