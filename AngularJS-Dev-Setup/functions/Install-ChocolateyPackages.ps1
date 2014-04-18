function Install-ChocolateyPackages {
	Write-Host "Installing Chocolatey packages..."

	$packages = @(
		'pscx',
		'7zip.commandline',
		'curl',
		'git',
		'poshgit',
		'git-credential-winstore',
		'SourceTree',
		'python',
		'libjpeg-turbo',
		'OptiPNG',
		'PhantomJS',
		'nodejs.install'
		#'stylecop',
		#'markdownpad2',
		#'PowerGUI',
	)
	$packages | foreach { cinst $_ }
}