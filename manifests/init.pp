class php {
	file {
		"/opt/php":
			ensure => directory,
	}

	package {
		"php5":
			ensure => latest,
	}
}

