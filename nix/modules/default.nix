{ lib, pkgs, config, ... }:

with lib;

let
  cfg = config.services.metacall;
in {
  options.services.metacall = {
    enable = mkEnableOption "MetaCall service";
    port = mkOption {
      type = types.port;
      default = 8080;
      description = "Port for MetaCall service";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.metacall ];
    
    systemd.services.metacall = {
      description = "MetaCall Service";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.metacall}/bin/metacall start --port ${toString cfg.port}";
        Restart = "on-failure";
      };
    };
  };
}