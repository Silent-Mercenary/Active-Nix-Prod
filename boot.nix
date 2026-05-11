{ ... }:
{
  boot = {
    blacklistedKernelModules = [
      "af_alg"
      "algif_hash"
      "algif_skcipher"
      "algif_rng"
      "algif_aead"
    ];

    loader = {
      systemd-boot.enable = true;

      efi = {
        canTouchEfiVariables = true;
      };
    };
  };
}

