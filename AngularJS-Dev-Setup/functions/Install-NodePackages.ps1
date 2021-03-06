function Install-NodePackages {
	Write-Host "Installing Global NodeJS packages..."

	if (!($env:Path -match "nodejs")) {
		$env:Path += ";$env:ProgramFiles\nodejs"
	}

	function Install-NodePackagesGlobal {
		param ([array]$packages)
		$packages | % {
			& "npm.cmd" "install" "-g" $_
		}
	}

	# Some node packages need VS2012 or VS2013 to build...
	# See: https://www.npmjs.org/package/node-gyp
	$vsVersion = "2012"
	if (Test-Path HKLM:\Software\Microsoft\VisualStudio\12.0) {
		$vsVersion = "2013"
	}
	npm.cmd config set msvs_version $vsVersion
	
	Install-NodePackagesGlobal(@(
		'yo',
		'grunt-cli',
		'bower',
		'generator-angular',
		'protractor',
		'karma',
		'karma-jasmine',
  		'karma-chrome-launcher',
  		'karma-ie-launcher',
  		'karma-ng-scenario',
  		'typescript'
	))

	npm cache clean

	# These ones below I need to confirm which are really needed:
	# selenium-webdriver
	# chromedriver
	# jasmine-node
	# selenium
}
