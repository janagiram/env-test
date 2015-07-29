/**
 * Set defaults
 */
# set default path for execution
Exec { path => '/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin' }

/**
 * Run "apt-get update" before installing packages
 */
exec { 'apt-update':
    command => '/usr/bin/apt-get update'
}
Exec['apt-update'] -> Package <| |>

exec { 'git-install':
  command => '/usr/bin/apt-get -y install build-essential git'
}
exec{'retrieve-modman':
  command => "/usr/bin/wget -q https://raw.github.com/colinmollenhour/modman/master/modman -O /usr/local/bin/modman",
  creates => "/usr/local/bin/modman",
}

file{'/usr/local/bin/modman':
  mode => 0755,
  require => Exec["retrieve-modman"],
}

package { 'curl':
    ensure => 'present',
}

group { 'puppet':
    ensure => 'present',
}

class { 'apache2':
    document_root => '/vagrant/html',
}

/**
 * MySQL config
 */
class { 'mysql':
    root_pass => 'r00t',
}

/**
 * Magento config
 */
class { 'magento':
    /* install magento [true|false] */
    install =>  true,
  	local =>  true,

  /* ENTERPRISE EDITION  : tar.gz Magento source available in puppet/modules/magento/files folder?          */
  version => 'Magento-EE-1.14.2.0.tar.gz',

  /* /* COMMUNITY EDITION
  source url in : puppet/modules/magento/manifests/init.pp
http://www.magentocommerce.com/downloads/assets/${version}/magento-${version}.tar.gz",*/
  /*  magento community versions (downloaded online)*/
  #version     => '1.9.0.1',
  #version     => '1.8.1.0',
  #version    => '1.7.0.2',
  #version    => '1.7.0.1',
  #version    => '1.7.0.0',
  #version    => '1.6.2.0',
  #version    => '1.6.1.0',
  #version    => '1.6.0.0',
  #version    => '1.5.1.0',
  #version    => '1.5.0.1',



  /* magento database settings */
    db_user     => 'magento',
    db_pass     => 'magento',

    /* magento admin user */
    admin_user  => 'admin',
    admin_pass  => 'admin123',

    /* use rewrites [yes|no] */
    use_rewrites => 'no',
  /*
  For base_url => 'http://magento.localhost.com'
  add :10.10.33.20      baseurl in hostmachine's "hosts" file
  */
    base_url => 'http://portwest.localhost.com/',
}


host { 'portwest.localhost.com':
  ip      => '10.10.33.20',
}

class { 'git':
  keyname => 'id_rsaLSGIT',
}

/**
 * Import modules
 */
include apt
include mysql
include apache2
include php5
include composer
include magento
include git
