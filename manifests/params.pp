class oracleclient::params {

    # sql thin client install i386
    #
    # rpm -ihv https://s3.eu-central-1.amazonaws.com/ar-ecd9f97f164d1a813fb4705c806208d2/ar-oraclient-rpm/oic-basic.rpm
    # rpm -ihv https://s3.eu-central-1.amazonaws.com/ar-ecd9f97f164d1a813fb4705c806208d2/ar-oraclient-rpm/oic-devel.rpm
    # rpm -ihv https://s3.eu-central-1.amazonaws.com/ar-ecd9f97f164d1a813fb4705c806208d2/ar-oraclient-rpm/oic-sqlplus.rpm

  case $::osfamily
  {
    'redhat':
    {
      case $::operatingsystemrelease
      {
        /^[67].*$/:
        {
        }
        default: { fail("Unsupported RHEL/CentOS version! - ${::operatingsystemrelease}")  }
      }
    }
    'Debian':
    {
      fail('Unsupported')
    }
    default: { fail('Unsupported OS!')  }
  }
}
