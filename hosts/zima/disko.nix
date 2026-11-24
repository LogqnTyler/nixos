{
  disko.devices = {

    disk.emmx = {
      type = "disk";
      device = "/dev/mmcblk0";
      content = {

        type = "gpt";
        partitions = {

          ESP = {
            size = "1G";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [ "umask=0077" ];
            };
          };

          root = {
            size = "100%";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/";
            };
          };
        };
      };

    };
    disk.ssd = {
      type = "disk";
      device = "/dev/nvme0n1";
      content = {
        type = "gpt";
        partitions = {

          swap = {
            size = "24G";
            type = "8200";
            content = {
              type = "swap";
              randomEncryption = true;
            };
          };

          zfs = {
            size = "100%";
            content = {
              type = "zfs";
              pool = "deepend";
            };
          };
        };
      };
    };
    zpool.deepend = {
      type = "zpool";
      options.ashift = "12";

      rootFsOptions = {
        compression = "lz4";
        mountpoint = "none";
      };
      datasets = {
        immich = {
          type = "zfs_fs";
          options.mountpoint = "legacy";
          mountpoint = "/srv/immich";
          mountOptions = [ "nofail" ];
        };

        postgresql = {
          type = "zfs_fs";
          options.mountpoint = "legacy";
          mountpoint = "/var/lib/postgresql";
          mountOptions = [ "nofail" ];
        };

        storage = {
          type = "zfs_fs";
          options.mountpoint = "legacy";
          mountpoint = "/srv/storage";
          mountOptions = [ "nofail" ];
        };
      };
    };
  };

}
