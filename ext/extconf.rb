require 'mkmf'

$CFLAGS ||= ''
have_library('tiff')
if have_library('tesseract_full')
elsif have_library('tesseract')
  $CFLAGS += ' -D_NEW_TESSERACT'
else
  STDERR.puts "Can't find tesseract library"
  exit 1
end

create_makefile('simple_tesseract_ext')
