function Install-RubyGems {
	Write-Host "Installing Ruby Gems..."

	if (!(Test-Path C:\ruby200\bin\ruby.exe)) {
		cinst ruby -force
	}

	cinst compass -source ruby
	gem install css_parser
}
