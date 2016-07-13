# == Class: winnetwork
#
# Manages proxy and dns configuration
#
# === Parameters
#
# [*None*]
#
# === Examples
#
#  include winnetwork
#
# === Authors
#
# songan.bui@thomsonreuters.com
#
# === Comment
#
# 
#
class winnetwork {
  file { 'c:/vc': ensure => directory }
  include winnetwork::proxy
  include winnetwork::dns
}