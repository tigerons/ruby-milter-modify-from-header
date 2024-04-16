Gem::Specification.new do |spec|
  spec.name          = "milter_modify_from_header"
  spec.version       = "0.0.1"
  spec.authors       = ["Matthew Sawczuk"]
  spec.email         = ["matthew1260@gmail.com"]
  spec.summary       = "Modify from header"
  spec.description   = "Modifies the from header - leaves only the email address"
  spec.license       = "GPL-3.0"

  spec.files         = spec.files = Dir.glob("**/*", File::FNM_DOTMATCH).reject { |file| File.directory?(file) || file.start_with?(".") }
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "milter", '~> 0.0.1'
  spec.add_dependency "simplecov", '~> 0.22.0'
  spec.add_dependency "daemons", '~> 1.4.1'
  spec.add_dependency "rspec", '~> 3.12'
end
