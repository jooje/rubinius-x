require 'rubygems'
require 'rubygems/installer'
require 'rubinius/build_config'

puts "Pre-installing gems for #{RUBY_VERSION}..."

BUILD_CONFIG = Rubinius::BUILD_CONFIG
gems = BUILD_CONFIG[:runtime_gems]
install_dir = "#{BUILD_CONFIG[:build_prefix]}#{BUILD_CONFIG[:gemsdir]}"
options = {
  :bin_dir              => nil,
  :build_args           => [],
  :env_shebang          => true,
  :force                => false,
  :format_executable    => false,
  :ignore_dependencies  => true,
  :security_policy      => nil,
  :user_install         => nil,
  :wrappers             => true,
  :install_as_default   => false,
  :install_dir          => install_dir
}

gems.each do |name, version|
  next if File.directory? "#{install_dir}/gems/#{name}-#{version}"

  file = File.expand_path "../../vendor/cache/#{name}-#{version}.gem", __FILE__
  installer = Gem::Installer.new file, options
  spec = installer.install
  puts "Installed #{spec.name} (#{spec.version})"
end
