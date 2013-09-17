# encoding: utf-8
$:.push File.expand_path("../lib", __FILE__)

require "evil_transform"

Gem::Specification.new do |s|
  s.name        = "evil_transform"
  s.version     = EvilTransform::VERSION
  s.authors     = ["zires"]
  s.email       = ["zshuaibin@gmail.com"]
  s.homepage    = "https://github.com/zires/evil_transform"
  s.summary     = "WGS-84 to GCJ-02."
  s.description = "[ruby译]地球坐标系 (WGS-84) 到火星坐标系 (GCJ-02) 的转换算法."
  s.license     = 'MIT'

  s.files = Dir["{lib}/**/*"] + ["LICENSE", "README.md"]
  s.test_files = Dir["test/**/*"]

  s.add_development_dependency "pry"
  s.add_development_dependency "yard"
  s.add_development_dependency "turn"
end
