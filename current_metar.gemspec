require 'rake'
Gem::Specification.new do |spec|
  spec.name = 'current_metar'
  spec.summary = 'Query current metar data from the ADDS Experimental data server.'
  spec.description = 'current_metar queries the ADDS Experimental server to pull back current weather data for a specific reporting station'
  spec.homepage = 'https://github.com/nathanhumbert/current_metar'
  spec.version = '0.1'
  spec.authors = ['Nathan Humbert']
  spec.email = ['nathan.humbert@gmail.com']
  spec.files = [
    'README',
    'MIT_LICENSE',
  ]
  spec.files += FileList['lib/**/*.rb']
  spec.test_files = FileList['tests/**/*.rb']
  spec.has_rdoc = true
  spec.license = 'MIT'
  spec.add_development_dependency('fakeweb')

end
