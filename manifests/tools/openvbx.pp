class php::tools::openvbx {
	include php::tools
}

define php::tools::openvbx::install ($domain) {
	include git

	$nginx_sitesavailable = '/etc/nginx/sites-available'
	$nginx_sitesenabled = '/etc/nginx/sites-enabled'
	$openvbx_repository = "git://github.com/twilio/OpenVBX.git"
	$openvbx_ref = "1.0.4"
	$webroot = "/var/www"
	$siteroot = "${webroot}/${domain}"
	$clone_to = "openvbx-1.0.4"

	file {
		"php::tools::openvbx::install::${name}-workingdir":
			name => "${siteroot}",
			ensure => directory,
	}

	git::clone {
		"openvbx-clone-${name}":
			url => "${openvbx_repository}",
			cwd => "${webroot}/${domain}",
			target => "${clone_to}",
			user => "root",
			notify => [
				Exec["php::tools::openvbx::install::${name}-ownership"],
				Exec["php::tools::openvbx::install::${name}-permissions"]
			],
			require => File["php::tools::openvbx::install::${name}-workingdir"],
	}

	exec {
		"php::tools::openvbx::install::${name}-ownership":
			command => "chown -R www-data:www-data ${siteroot}",
			refreshonly => true,
			path => ["/sbin", "/bin",
			         "/usr/sbin", "/usr/bin",
			         "/usr/local/sbin", "/usr/local/bin"],
	}

	exec {
		"php::tools::openvbx::install::${name}-permissions":
			command => "chmod -R 660 ${siteroot} && find ${siteroot} -type d -exec chmod 770 {} \;",
			refreshonly => true,
			path => ["/sbin", "/bin",
			         "/usr/sbin", "/usr/bin",
			         "/usr/local/sbin", "/usr/local/bin"],
	}

	file {
		"php::tools::openvbx::${name}-nginx":
			name => "${nginx_sitesavailable}/${domain}",
			owner => "www-data",
			group => "www-data",
			mode => 770,
			content => template('php/tools/openvbx/nginx_site.erb'),
	}

	file {
		"php::tools::openvbx::${name}-nginx-enabled":
			name => "${nginx_sitesenabled}/${domain}",
			ensure => link,
			target => "${nginx_sitesavailable}/${domain}",
			require => File["php::tools::openvbx::${name}-nginx"],
			notify => Service["nginx"],
	}
}

