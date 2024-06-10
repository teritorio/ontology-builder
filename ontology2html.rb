require 'json'

ontology = ARGV[0]
ontology = JSON.parse(File.read(ontology))

def i18n(label)
  label.collect{ |key, text| "#{key}: #{text}" }.join(', ')
end

def icon(color_fill, font)
  "<td style='background: #{color_fill}; color: white; font-size: 200%; padding: 5px'>
    <center><i class='teritorio teritorio-#{font}'></i></center>
  </td>"
end

def leaf(color_fill, color_line, font, id, c)
  "<tr><td></td><td></td><td></td><td></td><td></td><td></td>
  #{icon(color_fill, font)}
  <td>#{id}</td>
  <td>#{i18n(c["label"])}</td>
  <td>#{c["style"]}</td>
  <td>#{c["zoom"]}</td>
  <td>#{c["priority"]}</td>
  <td>#{c["osm_tags"].join(' or</br>')}</td>
  <td>#{c["osm_tags_extra"].join(', ')}</td>
  </tr>"
end

title = ontology["name"]
html = "<html><head>
  <title>#{title}</title>
  <link rel='stylesheet' href='https://unpkg.com/@teritorio/font-teritorio/teritorio/teritorio.css'>
  <style>
  table, td, th {
    border: 1px solid black;
    border-collapse: collapse;
    padding: 2px;
  }
  </style>
</head>
<body><h1>#{title}</h1><table>"
html += "<tr>
  <th></th><th>superclass_id</th><th>superclass label</th>
  <th></th><th>class_id</th><th>class label</th>
  <th></th><th>subclass_id</th><th>subclass label</th>
  <th>i</th><th>z</th><th>p</th>
  <th>Overpass</th>
  <th>Extra tags</th>
  </tr>"
ontology["superclass"].each { |superclass_id, superclass|
  color_fill = superclass["color_fill"]
  html += "<tr>#{icon(color_fill, superclass_id)}<td>#{superclass_id}</td><td colspan='99'>#{i18n(superclass["label"])}</td></tr>"
  superclass["class"].each { |class_id, classs|
    if classs["subclass"]
      html += "<tr><td></td><td></td><td></td>#{icon(color_fill, class_id)}<td>#{class_id}</td><td colspan='99'>#{i18n(classs["label"])}</td></tr>"
      classs["subclass"].each { |subclass_id, subclass|
        html += leaf(
          color_fill,
          superclass["color_line"],
          subclass_id,
          subclass_id,
          subclass,
        )
      }
    else
      html += leaf(
        color_fill,
        superclass["color_line"],
        class_id,
        class_id,
        classs,
      )
    end
  }
}
html += "</table></body></html>"
puts html
