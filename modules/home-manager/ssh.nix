# ssh.nix
{ ... }:

{
  programs.ssh = {
    enable = true;

    settings = {
      thebeast = {
        HostName = "100.78.220.41";
        User = "tpv";
        RequestTTY = "yes";
        RemoteCommand = "cd ~/LoganData && exec $SHELL -l";
      };

      portal = {
        HostName = "portal.cs.virginia.edu";
        User = "zup7mn";
      };

      gpusrv = {
        HostName = "gpusrv03";
        User = "zup7mn";
        ProxyJump = "portal";
      };

      mini = {
        HostName = "mini";
        User = "logan";
      };

      worker2 = {
        HostName = "worker2";
        User = "logan";
      };
    };
  };
}
