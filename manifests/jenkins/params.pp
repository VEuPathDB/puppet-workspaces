# This class manages workspaces(WS) specific jenkins configurations

class workspaces::jenkins::params {
  $wrkspuser          = "wrkspuser"
  $url                = "http://localhost"
  $wrksptoken         = $::wrkspuser_token
  $dslconfig          = "/usr/local/home/jenkins/Instances/WS/dslconfig.groovy"
  $nodes              = undef
  $adminusers         = undef
  $site_environment   = "savm"
  $confset            = "wij_configuration_set"
  $instance_home      = "/usr/local/home/jenkins/Instances/WS"
  $static_users       = []
  $notification_email = undef
  $notification_sender_email = undef

  #ldap options should be specified in hiera
  $use_ldap             = false
  $ldap_server          = undef
  $ldap_rootDN          = undef
  $ldap_userSearchBase  = undef
  $ldap_userSearch      = undef
  $ldap_groupSearchBase = undef
  $ldap_managerDN       = undef
  $ldap_managerPassword = undef


  $plugins = [
    'antisamy-markup-formatter',
    'ant',
    'build-blocker-plugin',
    'build-timeout',
    'credentials',
    'email-ext',
    'external-monitor-job',
    'git',
    'git-client',
    'github',
    'gradle',
    'groovy',
    'groovy-postbuild',
    'job-dsl',
    'junit',
    'mailer',
    'matrix-auth',
    'matrix-project',
    'maven-plugin',
    'parameterized-trigger',
    'pipeline-stage-step',
    'pipeline-milestone-step',
    'pipeline-build-step',
    'pipeline-input-step',
    'pipeline-graph-analysis',
    'pipeline-rest-api',
    'pipeline-stage-view',
    'plain-credentials',
    'preSCMbuildstep',
    'resource-disposer',
    'role-strategy',
    'run-condition',
    'scm-api',
    'script-security',
    'ssh-credentials',
    'ssh-slaves',
    'structs',
    'subversion',
    'token-macro',
    'workflow-aggregator',
    'workflow-support',
    'ws-cleanup',
  ]

}
