require 'prawn'
require 'yaml'
require 'optparse'

data = open('style.yaml', 'r') { |f| YAML.load(f) }

fonts = {}
fonts[:ipaexg] = 'fonts/ipaexg.ttf'

def add_string(pdf, data)
  x = data['x']
  y = data['y']
  size = data['size']
  str = data['str']
  w = x + size * str.to_s.size
  h = size

  p data
  pdf.bounding_box([x, y], width: w, height: h) do
    pdf.font_size size
    pdf.text str
  end
end

def add_line(pdf, data)
  x = data['x']
  y = data['y']
  w = data['w']
  h = data['h']

  p data

  pdf.line_width(32)
  pdf.line(x, y, x + w, y + h)
  pdf.stroke
end

Prawn::Document.generate('output.pdf',
                         page_size: 'A4') do |pdf|
  pdf.font fonts[:ipaexg]

  data.each do |k, v|
    p k
    add_line(pdf, v) if k == 'line'
    add_string(pdf, v) if k == 'string'
  end
end
