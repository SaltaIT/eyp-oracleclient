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
                                    $tns_admin                 = undef,
                                    $order                     = '42',
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

  # instantclient: http://www.oracle.com/technetwork/database/features/oci/ic-faq-094177.html#A5028
  #
  # How do I ensure that my Oracle Net files like "tnsnames.ora" and
  # "sqlnet.ora" are being used in Instant Client?
  #
  # Files like "tnsnames.ora", "sqlnet.ora" and "oraaccess.xml" will be located
  # by Instant Client by setting the TNS_ADMIN environment variable or registry
  # entry to the directory containing the files. Use the full directory path;
  # do not include a file name.

  Exec {
    path => '/usr/sbin:/usr/bin:/sbin:/bin',
  }

  if($csalias)
  {
    validate_array($csalias)
  }

  if($tns_admin!=undef)
  {
    $target_tnsnames="${tns_admin}/tnsnames.ora"
  }
  else
  {
    $target_tnsnames="${oracleclient::oraclehome}/network/admin/tnsnames.ora"
  }

  if(!defined(Concat[$target_tnsnames]))
  {
    exec { "mkdir p tnsnames ${tns_admin}":
      command => "mkdir -p ${tns_admin}",
      creates => $tns_admin,
    }

    concat { $target_tnsnames:
      ensure  => 'present',
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      require => Exec["mkdir p tnsnames ${tns_admin}"],
    }
  }

  if(!defined(Concat::Fragment['tnsnames header']))
  {
    concat::fragment{ 'tnsnames header':
      target  => $target_tnsnames,
      order   => '00',
      content => "#\n# puppet managed file\n#\n",
    }
  }

  concat::fragment{ "tnsnames ${csname}":
    target  => $target_tnsnames,
    order   => $order,
    content => template("${module_name}/tnsnames.erb"),
  }
}
