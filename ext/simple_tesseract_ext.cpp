#include <stdio.h>
#include <ruby/ruby.h>
#include <tiffio.h>
#include <tesseract/img.h>
#include <tesseract/imgs.h>
#include <tesseract/baseapi.h>

void read_tiff_image(TIFF* tif, IMAGE* image);

#ifdef _NEW_TESSERACT
using namespace tesseract;
#endif

extern "C" {
  VALUE rb_cTesseract;

  VALUE
  rb_cTesseract_get_text(VALUE self, VALUE language, VALUE file,
      VALUE rx, VALUE ry, VALUE rwidth, VALUE rheight) {
    const char *lang = (const char *)(language == Qnil ? NULL : RSTRING_PTR(language));
    TIFF * tif = TIFFOpen(RSTRING_PTR(file), "r");
    int x = NUM2INT(rx),
        y = NUM2INT(ry),
        width = NUM2INT(rwidth),
        height = NUM2INT(rheight);
    IMAGE img;
    read_tiff_image(tif, &img);
    int bytes_per_line = check_legal_image_size(img.get_xsize(),
        img.get_ysize(), img.get_bpp());

    char *text;
#if _NEW_TESSERACT
    TessBaseAPI api; api.Init(NULL, lang);
    text = api.TesseractRect(img.get_buffer(), img.get_bpp()/8,
        bytes_per_line, x, y, width, height);
#else
    TessBaseAPI::InitWithLanguage(NULL, NULL, lang, NULL, false, 0, NULL);
    text = TessBaseAPI::TesseractRect(img.get_buffer(), img.get_bpp()/8,
        bytes_per_line, x, y, width, height);
    TessBaseAPI::End();
#endif
    TIFFClose(tif);

    return rb_str_new2(text);
  }

  void
  Init_simple_tesseract_ext() {
    rb_cTesseract = rb_define_class("Tesseract", rb_cObject);
    rb_define_private_method(rb_cTesseract, "get_text", (VALUE (*)(...))rb_cTesseract_get_text, 6);
  }
}
