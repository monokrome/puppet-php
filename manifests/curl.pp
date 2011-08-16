class php::curl {
	package {
		"php5-curl":
			ensure => installed,
			notify => Service["php5-fpm"],
	}
}

