simple\_tesseract
=================

USAGE:

```ruby
t = Tesseract.new(opts)
```

Options:
  blob\n
  src || source || image\n
  strip\n
  lang || language\n
  editor

Evaluate the whole image:

```ruby
puts t.to_s
```

Evaluate only some pieces of image:

```ruby
puts t.crops([0, 0, 50, 50], [50, 50, 50, 50])
```
