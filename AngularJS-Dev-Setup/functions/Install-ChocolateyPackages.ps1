function Install-ChocolateyPackages {
	Write-Host "Installing Chocolatey packages..."

	if (!($env:Path -match 'git')) {
		$env:Path += ';C:\Program Files\Git\cmd'
	}
	
	$packages = @(
		'pscx',
		'7zip.commandline',
		'curl',
		'git',
		'poshgit',
		'git-credential-winstore',
		'SourceTree',
		'libjpeg-turbo',
		'OptiPNG',
		'PhantomJS',
		'nodejs.install'
		#'python',
		#'stylecop',
		#'markdownpad2',
		#'PowerGUI',
	)
	$packages | foreach { cinst $_ }
}