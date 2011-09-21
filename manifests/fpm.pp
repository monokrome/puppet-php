class php::fpm {
	package {
		"php5-fpm":
			ensure => installed,
	}

	service {
		"php5-fpm":
			ensure => running,
			require => Package["php5-fpm"],
	}
}

