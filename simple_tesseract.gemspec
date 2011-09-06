Gem::Specification.new {|g|
    g.name          = 'simple_tesseract'
    g.version       = '0.0.1'
    g.author        = 'shura'
    g.email         = 'shura1991@gmail.com'
    g.homepage      = 'http://github.com/shurizzle/simple_tesseract'
    g.platform      = Gem::Platform::RUBY
    g.description   = 'tesseract ruby bindings'
    g.summary       = g.description.dup
    g.files         = Dir['lib/**/*'] + Dir['ext/*']
    g.require_path  = 'lib'
    g.executables   = [ ]
    g.extensions    = 'ext/extconf.rb'

    g.add_dependency('rmagick')
}
