class php::tools {
	include php
	include php::fpm
	include php::mysql

	file {
		"/opt/php/tools":
			ensure => directory,
	}
}

