require 'RMagick'
require 'simple_tesseract_ext'
require 'stringio'

class Tesseract
  attr_reader :src, :blob
  attr_accessor :lang, :editor

  def initialize (opts={})
    @lang = opts.delete(:lang) || opts.delete(:language) || 'eng'
    self.src = opts.delete(:src) || opts.delete(:source) || opts.delete(:image)
    self.blob = opts.delete(:blob)
    @editor = opts.delete(:editor) || lambda {|x|x}
    self.strip = opts.delete(:strip)
    @tmp = Tempfile.new(['rbtesseract', '.tiff']).tap {|x| x.close }.path

    ObjectSpace.define_finalizer(self, method(:finalize))
  end

  def src= (file)
    @blob = nil if file
    @src = file
  end

  def blob= (string)
    @src = nil if string
    @blob = string
  end

  def strip= (bool)
    @strip = !!bool
  end

  def strip?
    @strip
  end

  alias language lang
  alias language= lang=
  alias source src
  alias source= src=
  alias image src
  alias image= src=

  def solve (x=0, y=0, width=nil, height=nil)
    editor.call((@src ? Magick::Image.read(@src) : Magick::Image.from_blob(@blob)).first).write(@tmp)
    img = Magick::Image.read(@tmp).first
    x ||= 0
    y ||= 0
    width ||= img.columns
    height ||= img.rows

    get_text(@lang, @tmp, x, y, width, height).tap {|x|
      x.strip! if strip?
    }
  end

  def crops (*areas)
    areas.map {|area|
      solve(*area)
    }.join
  end

  def to_s
    solve
  end

  def finalize
    File.unlink(@tmp) rescue nil
  end
  alias close finalize
end
