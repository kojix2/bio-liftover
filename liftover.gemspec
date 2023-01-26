Gem::Specification.new do |spec|
  spec.name          = 'liftover'
  spec.version       = '1.4.0'
  spec.authors       = ['kojix2', 'Andrei Rozanski']
  spec.email         = ['2xijok@gmail.com', 'andrei@ruivo.org']

  spec.summary       = 'Ruby solution for UCSC LiftOver tool- (UCSC http://genome.ucsc.edu/cgi-bin/hgLiftOver)'
  spec.description   = 'Simple, under development Ruby solution for UCSC LiftOver tool'
  spec.homepage      = 'http://github.com/kojix2/bioruby-liftover'
  spec.license       = 'MIT'

  spec.files         = Dir['*.{md,txt}', '{lib,exe}/**/*']
  spec.require_paths = ['lib']

  spec.add_dependency 'interval-tree'
end
