define oracleclient::connectstring(
                                    $host,
                                    $dbname                    = undef,
                                    $csname                    = $name,
                                    $csalias                   = undef,
                                    $port                      = '1521',
                                    $shared                    = false,
                                    $loadbalance               = 'off',
                                    $failover                  = 'on',
                                    $connect_timeout           = '5',
                                    $transport_connect_timeout = '3',
                                    $retry_count               = '3',
                                    $instance_name             = undef,
                                    $description               = undef,
                                    $community                 = undef,
                                    $sid                       = undef,
                                    $global_name               = undef,
                                  ) {

  # example
  #
  # HYBRIS =
  # (DESCRIPTION =
  #   (ADDRESS = (PROTOCOL = TCP)(HOST = accvhdt.l0l.systemadmin.es)(PORT = 1521))
  #   (CONNECT_DATA =
  #     (SERVER = DEDICATED)
  #     (SERVICE_NAME = HYBRIS)
  #   )
  # )

  # PROD1=
  # (DESCRIPTION=
  #   (ADDRESS=(PROTOCOL=tcp)(HOST=systemadmindb01-vip.systemadmin.es)(PORT=1521))
  #   (CONNECT_DATA=
  #       (SERVICE_NAME=PROD)
  #       (INSTANCE_NAME=PROD1)
  #   )
  # )

  # DWQ =
  #   (DESCRIPTION =
  #     (ADDRESS_LIST =
  #       (ADDRESS =
  #         (COMMUNITY = tcp.world) (PROTOCOL = TCP) (Host = 172.28.222.71 ) (Port = 11214 ) ) )
  #       (CONNECT_DATA = (SID = DWQ ) (GLOBAL_NAME = DWQ ) ) )
  #
  # DWIASDEV =
  #   (DESCRIPTION =
  #     (ADDRESS_LIST =
  #       (ADDRESS =
  #         (COMMUNITY = tcp.world) (PROTOCOL = TCP) (Host = 172.28.222.18 ) (Port = 10200 ) ) )
  #         (CONNECT_DATA = (SID = DWIAS ) (GLOBAL_NAME = DWIAS ) ) )

  if($csalias)
  {
    validate_array($csalias)
  }

  #TODO: afegir banner amb puppet managed file
  if(!defined(Concat::Fragment['tnsnames header']))
  {
    concat::fragment{ 'tnsnames header':
      target  => "${oracleclient::oraclehome}/network/admin/tnsnames.ora",
      order   => '00',
      content => "#\n# puppet managed file\n#\n",
    }
  }

  concat::fragment{ "tnsnames ${csname}":
    target  => "${oracleclient::oraclehome}/network/admin/tnsnames.ora",
    order   => '42',
    content => template("${module_name}/tnsnames.erb"),
  }
}
