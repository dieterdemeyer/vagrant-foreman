class ssl_certificates {

  file { 'certs':
    ensure  => link,
    target  => "/etc/cegeka/ssl/certs/${vagrant_box_name}.example.com.pem",
    path    => "/etc/cegeka/ssl/certs/${vagrant_host_name}.pem"
  }

  file { 'private_keys':
    ensure  => link,
    target  => "/etc/cegeka/ssl/private_keys/${vagrant_box_name}.example.com.pem",
    path    => "/etc/cegeka/ssl/private_keys/${vagrant_host_name}.pem"
  }

}
