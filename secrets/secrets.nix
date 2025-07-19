let
  nejrobbins_gmail_com = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHBROs/XTz22QVUf1bhruq/FgrE+GHKkS77sR7Q3GJL2 nejrobbins_gmail_com";
  users = [ nejrobbins_gmail_com ];

  robbins-page-webserver = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILnF/O8TKXr/EYoMHAu+hYA+zJ2kdCsgpoj3X1CsfGwg";
  systems = [ robbins-page-webserver ];
in
{
  "cloudflare-api-token.age".publicKeys = users ++ systems;
}
