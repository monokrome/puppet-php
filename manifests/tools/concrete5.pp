class php::tools::concrete5 {
	include php::tools
}

define php::tools::concrete5::install ($domain) {
	include nginx
	include utility::unzip

	$concrete5_source = 'http://www.concrete5.org/download_file/-/view/27827/8497/'
	$concrete5_archive = 'concrete5.4.2.zip'
	$concrete5_working_dir = '/opt/php/tools/concrete5'
	$nginxsites = '/etc/nginx/sites-available'
	$webroot = '/var/www'
	$siteroot = "${webroot}/${domain}/concrete5.4.2"

	file {
		"php::tools::concrete5::install::${name}-workingdir":
			name => "${concrete5_working_dir}",
			ensure => directory,
	}

	exec {
		"php::tools::concrete5::install::${name}-download":
			command => "wget '${concrete5_source}' -O '${concrete5_archive}'",
			cwd => "${concrete5_working_dir}",
			creates => "${concrete5_working_dir}/${concrete5_archive}",
			require => File["php::tools::concrete5::install::${name}-workingdir"],
			path => ["/sbin", "/bin",
			         "/usr/sbin", "/usr/bin",
			         "/usr/local/sbin", "/usr/local/bin"],
	}

	exec {
		"php::tools::concrete5::install::${name}-unzip":
			command => "unzip '${concrete5_archive}' -d '${webroot}/${domain}'",
			cwd => "${concrete5_working_dir}",
			require => [Exec["php::tools::concrete5::install::${name}-download"], Package["unzip"]],
			creates => "${siteroot}",
			path => ["/sbin", "/bin",
			         "/usr/sbin", "/usr/bin",
			         "/usr/local/sbin", "/usr/local/bin"],
	}

	file {
		"php::tools::concrete5::${domain}-nginx":
			name => "${nginxsites}/${domain}",
			owner => "www-data",
			group => "www-data",
			mode => 770, # Concrete5 team recommend 755, but that really makes little sense.
			content => template('php/tools/concrete5/nginx_site.erb'),
			require => [Exec["php::tools::concrete5::install::${name}-unzip"], Package["nginx"]],
	}
}

