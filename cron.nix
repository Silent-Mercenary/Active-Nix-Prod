{ pkgs, ... }:
{
	services.cron = {
	  enable = true;
	  systemCronJobs = [
	    # run as root every minute
	    "*/4 * * * * root /bin/sh /var/cronapache.sh  >> /var/log/crontab.apache 2>&1"
	  ];
	};
}
