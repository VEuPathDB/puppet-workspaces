class workspaces::params {

  # these need to come from hiera directly, since the workspaces class
  # will not always be on the same node as the workspaces::jenkins class.
  # Also, referencing variables in other classes does not do magic
  # hiera override :(

  $wrkspuser         = lookup({'name' => 'workspaces::jenkins::wrkspuser'})
  $wrksptoken        = lookup({"name" => "workspaces::jenkins::wrksptoken", "default_value" => $::wrkspuser_token}) # default to wrkspuser_token fact
  $wrkspurl          = lookup({'name' => 'workspaces::jenkins::url'})

  $checkout_location = "/vagrant/scratch/svn_files"
  $checkout_revision = "HEAD"
  $branch            = "trunk"

  $cron_enable = true

}
