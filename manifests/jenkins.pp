# Class: workspaces::jenkins
# ===========================
#
# This class manages workspaces(WS) specific jenkins configurations
#
# Parameters
# ----------
#
# Document parameters here.
#
# * `dslconfig`
# path to the dslconfig file, used to configure jenkins groovy scripts
# 
# * `url`
# full url of the jenkins installation
#
# * `wrkspuser`
# the username of the workspaces jenkins user - defaults to 'wrkspuser'
#
# * `nodes`
# a list of jekins nodes to configure.  This is an array of name, host, 
# label.
#
# * `adminusers`
# a list of users that should have admin privileges.
#
# * `site_environment`
# the environment used by jenkins jobs to configure projects.  This is 
# currently only going to be savm, production, but could include qa
#
# * `confset`
# the name of the confset file in svn used to configure what projects
# run N/S and on what databases
#
# * `instance_home`
# The path to the jenkins instance home.  defaults to 
# /usr/local/home/jenkins/Instances/WS
#
# * `static_users`
# users to configure statically, if not using ldap.  It is an array of
# user,pass.  defaults to an empty list, which will configure no users
#
# * `svn_build_poll`
# configures whether or not to do builds based on svn polling
#
# * `branch`
# what branch to pull svn updates from.  Defaults to 'trunk'
#
# * `notification_email`
# notification email address jenkins uses for errors & failures
#
# * `notification_sender_email`
# this sets the sender address of the notification email.  Should be different
# than the notification email.
#
# * `plugins`
# a list of jenkins plugins to install
#
# * `use_ldap`
# boolean that configures if ldap is used for login or not.  If true,
# the rest of the ldap_* parameters need to be specified.
#
# ldap_* options should be self explanatory:
# * `ldap_server`
# * `ldap_rootDN`
# * `ldap_userSearchBase`
# * `ldap_userSearch`
# * `ldap_groupSearchBase`
# * `ldap_managerDN`
# * `ldap_managerPassword`

#
# Variables
# ----------
#
# Examples
# --------
#
# include workspaces::jenkins

class workspaces::jenkins ( 

  $dslconfig           = $::workspaces::jenkins::params::dslconfig,
  $url                 = $::workspaces::jenkins::params::url,
  $wrkspuser           = $::workspaces::jenkins::params::wrkspuser,
  $nodes               = $::workspaces::jenkins::params::nodes,
  $adminusers          = $::workspaces::jenkins::params::adminusers,
  $site_environment    = $::workspaces::jenkins::params::site_environment,
  $confset             = $::workspaces::jenkins::params::confset,
  $instance_home       = $::workspaces::jenkins::params::instance_home,
  $static_users        = $::workspaces::jenkins::params::static_users,
  $svn_build_poll      = $::workspaces::jenkins::params::svn_build_poll,
  $branch              = $::workspaces::jenkins::params::branch,
  $notification_email  = $::workspaces::jenkins::params::notification_email,
  $notification_sender_email  = $::workspaces::jenkins::params::notification_sender_email,
  $plugins             = $::workspaces::jenkins::params::plugins,

  $use_ldap             = $::workspaces::jenkins::params::use_ldap,
  $ldap_server          = $::workspaces::jenkins::params::ldap_server,
  $ldap_rootDN          = $::workspaces::jenkins::params::ldap_rootDN,
  $ldap_userSearchBase  = $::workspaces::jenkins::params::ldap_userSearchBase,
  $ldap_userSearch      = $::workspaces::jenkins::params::ldap_userSearch,
  $ldap_groupSearchBase = $::workspaces::jenkins::params::ldap_groupSearchBase,
  $ldap_managerDN       = $::workspaces::jenkins::params::ldap_managerDN,
  $ldap_managerPassword = $::workspaces::jenkins::params::ldap_managerPassword,

  
) inherits workspaces::jenkins::params {

  $init_groovy = "${instance_home}/init.groovy.d"

  # this handles user and plugin setup
  file { "${init_groovy}/10_init.groovy":
    ensure  => 'file',
    content => template('workspaces/init.groovy.erb'),
    notify  => Service['jenkins@WS'],
    owner   => 'jenkins',
    mode    => '0600'
  }

  # this sets up role based authentication
  file { "${init_groovy}/15_auth.groovy":
    ensure  => 'file',
    content => template('workspaces/auth.groovy.erb'),
    notify  => Service['jenkins@WS'],
    owner   => 'jenkins',
    mode    => '0600'
  }

  # this creates the irods node
  file { "${init_groovy}/20_irods_node.groovy":
    ensure  => 'file',
    content => template('workspaces/irods_node.groovy.erb'),
    notify  => Service['jenkins@WS'],
    owner   => 'jenkins',
    mode    => '0600'
  }

  # this executes the irodsWorkspacesJobs.groovy script
  file { "${init_groovy}/60_seed_job.groovy":
    ensure  => 'file',
    content => template('workspaces/seed_job.groovy.erb'),
    notify  => Service['jenkins@WS'],
    owner   => 'jenkins',
    mode    => '0600'
  }

  # this creates the views
  file { "${init_groovy}/65_create_view.groovy":
    ensure  => 'file',
    content => template('workspaces/create_view.groovy.erb'),
    notify  => Service['jenkins@WS'],
    owner   => 'jenkins',
    mode    => '0600'
  }

  file { '/usr/local/home/jenkins/irodsWorkspacesJobs.groovy':
    ensure  => 'file',
    content => template('workspaces/irodsWorkspacesJobs.groovy.erb'),
    notify  => Service['jenkins@WS'],
    owner   => 'jenkins',
    mode    => '0600'
  }

  # template for all groovy script confs
  file { $dslconfig:
    ensure  => 'file',
    content => template('workspaces/dslconfig.groovy.erb'),
    notify  => Service['jenkins@WS'],
    owner   => 'jenkins',
    mode    => '0600'
  }

  # ldap config
  if $use_ldap {
    $ldap_ensure = 'file'
  }
  else {
    $ldap_ensure = 'absent'
  }

  file { "${init_groovy}/15_ldap.groovy":
    ensure  => $ldap_ensure,
    content => template('workspaces/ldap.groovy.erb'),
    notify  => Service['jenkins@WS'],
    owner   => 'jenkins',
    mode    => '0600'
  }

  if $environment == "savm" {
    # The below script creates /usr/local/home/jenkins/jenkins_token.txt, which
    # is then linked to /etc/facter/facts.d/ to provide this token as a fact.
    # In a production scenario, the token is static and set in hiera directly
    # (as $::workspaces::jenkins::wrksptoken)


    file { "${init_groovy}/12_token.groovy":
      ensure  => 'file',
      content => template('workspaces/token.groovy.erb'),
      notify  => Service['jenkins@WS'],
      owner   => 'jenkins',
      mode    => '0600'
    }

    file { ['/etc/facter', '/etc/facter/facts.d']:
      ensure => directory,
    }

    file { '/etc/facter/facts.d/jenkins_token.txt':
      ensure => link,
      target => '/usr/local/home/jenkins/jenkins_token.txt',
      mode   => '700',
    }
  }

}
