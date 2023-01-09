let
  nejrobbins_gmail_com = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICKBakFT1Zg1bsxXhAEKKLOVRxmFf/JwQ2Vym1N3tstk nejrobbins_gmail_com";
  users = [ nejrobbins_gmail_com ];

  robbins-page-webserver = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOow30s6wr72VcQe/Y5XaVBn1c4Zr9qXHv91z70zDsST";
  systems = [ robbins-page-webserver ];
in
{
  "cloudflare-api-token.age".publicKeys = users ++ systems;
}
