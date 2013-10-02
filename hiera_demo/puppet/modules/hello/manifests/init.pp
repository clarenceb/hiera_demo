class hello {

  #######################
  # Hiera - single values
  #######################

  $magic_word = hiera('magic_word')
  notify { "Magic Word is: $magic_word": }

  $otherword = hiera('other_word')
  notify { "Other word is: $otherword": }

  ###########################
  # Hiera - encrypted secrets 
  ###########################

  $top_secret = hiera('top_secret')
  notify { $top_secret: }

  #########################
  # Hiera - array of values
  #########################

  $users_array = hiera_array('users_array')
  notify { $users_array: }

  ########################
  # Hiera - hash of values
  ########################

  $settings_hash = hiera_hash('settings_hash')
  notify { $settings_hash: }
 
  ######################################################
  # Example of creating some resources using hiera data.
  ######################################################
  define users {
    user { $title:
      ensure => present,
      shell  => '/bin/bash',
      home   => "/home/$title"
    }
  }
  users { $users_array: }
}

