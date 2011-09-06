require 'mkmf'

have_library('tiff')
have_library('tesseract_full')

create_makefile('simple_tesseract_ext')
