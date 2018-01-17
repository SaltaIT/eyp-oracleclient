#
# https://s3.eu-central-1.amazonaws.com/ar-ecd9f97f164d1a813fb4705c806208d2/ar-oraclient-rpm/oic-basic.rpm
# https://s3.eu-central-1.amazonaws.com/ar-ecd9f97f164d1a813fb4705c806208d2/ar-oraclient-rpm/oic-devel.rpm
# https://s3.eu-central-1.amazonaws.com/ar-ecd9f97f164d1a813fb4705c806208d2/ar-oraclient-rpm/oic-sqlplus.rpm
#
class oracleclient::instantclient (
                                    $basic_url      = undef,
                                    $devel_url      = undef,
                                    $sqlpus_url     = undef,
                                    $tools_url      = undef,
                                    $ver            = '11.2',
                                    $package_ensure = 'installed',
                                    $srcdir         = '/usr/local/src',
                                  ) inherits oracleclient::params {

  Exec {
    path => '/bin:/sbin:/usr/bin:/usr/sbin',
  }

  if($basic_url==undef or $sqlpus_url==undef)
  {
    fail('URLs missing, basic_url and sqlpus_url are required')
  }

  exec { 'which wget eyp-oracleclient instantclient':
    command => 'which wget',
    unless  => 'which wget',
  }

  exec { "mkdir p oracleclient instantclient ${srcdir}":
    command => "mkdir -p ${srcdir}",
    creates => $srcdir,
  }

  exec { "wget instantclient basic ${srcdir}":
    command => "wget ${basic_url} -O ${srcdir}/oracle-instantclient${ver}-basic.rpm",
    creates => "${srcdir}/oracle-instantclient${ver}-basic.rpm",
    require => Exec[ [ 'which wget eyp-oracleclient instantclient', "mkdir p oracleclient instantclient ${srcdir}" ] ],
  }

  # [root@centos7 src]# rpm -Uvh oracle-instantclient11.2-basic.rpm
  # Preparing...                          ################################# [100%]
  # Updating / installing...
  #    1:oracle-instantclient11.2-basic-11################################# [100%]

  package { "oracle-instantclient${ver}-basic":
    ensure   => $package_ensure,
    provider => 'rpm',
    source   => "${srcdir}/oracle-instantclient${ver}-basic.rpm",
    require  => Exec["wget instantclient basic ${srcdir}"],
  }

  exec { "wget instantclient sqlplus ${srcdir}":
    command => "wget ${sqlpus_url} -O ${srcdir}/oracle-instantclient${ver}-sqlplus.rpm",
    creates => "${srcdir}/oracle-instantclient${ver}-sqlplus.rpm",
    require => Exec[ [ 'which wget eyp-oracleclient instantclient', "mkdir p oracleclient instantclient ${srcdir}" ] ],
  }

  # [root@centos7 src]# rpm -Uvh oracle-instantclient11.2-sqlplus.rpm
  # Preparing...                          ################################# [100%]
  # Updating / installing...
  #    1:oracle-instantclient11.2-sqlplus-################################# [100%]

  package { "oracle-instantclient${ver}-sqlplus":
    ensure   => $package_ensure,
    provider => 'rpm',
    source   => "${srcdir}/oracle-instantclient${ver}-sqlplus.rpm",
    require  => [ Exec["wget instantclient sqlplus ${srcdir}"], Package["oracle-instantclient${ver}-basic"] ],
  }

  if($tools_url!=undef)
  {
    exec { "wget instantclient tools ${srcdir}":
      command => "wget ${tools_url} -O ${srcdir}/oracle-instantclient${ver}-tools.rpm",
      creates => "${srcdir}/oracle-instantclient${ver}-tools.rpm",
      require => Exec[ [ 'which wget eyp-oracleclient instantclient', "mkdir p oracleclient instantclient ${srcdir}" ] ],
    }

    package { "oracle-instantclient${ver}-tools":
      ensure   => $package_ensure,
      provider => 'rpm',
      source   => "${srcdir}/oracle-instantclient${ver}-tools.rpm",
      require  => [ Package["oracle-instantclient${ver}-basic"], Exec["wget instantclient tools ${srcdir}"] ],
    }
  }

  if($devel_url!=undef)
  {
    exec { "wget instantclient devel ${srcdir}":
      command => "wget ${devel_url} -O ${srcdir}/oracle-instantclient${ver}-devel.rpm",
      creates => "${srcdir}/oracle-instantclient${ver}-devel.rpm",
      require => Exec[ [ 'which wget eyp-oracleclient instantclient', "mkdir p oracleclient instantclient ${srcdir}" ] ],
    }

    # [root@centos7 src]# rpm -Uvh oracle-instantclient11.2-devel.rpm
    # Preparing...                          ################################# [100%]
    # Updating / installing...
    #    1:oracle-instantclient11.2-devel-11################################# [100%]

    package { "oracle-instantclient${ver}-devel":
      ensure   => $package_ensure,
      provider => 'rpm',
      source   => "${srcdir}/oracle-instantclient${ver}-devel.rpm",
      require  => [ Exec["wget instantclient devel ${srcdir}"], Package["oracle-instantclient${ver}-basic"] ],
    }
  }

}
