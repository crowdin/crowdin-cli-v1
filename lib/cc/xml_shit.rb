require 'rexml/document'
require 'csv'

class XmlShit
  def initialize(defaults = nil)
  end

  # string::
  #   XML source. Could be one of the following:
  #
  #   - XML string: Parses string.
  #
  def xml_in(string)
    if string.is_a?(String)
      if string =~ /<.*?>/m
        @doc = parse(string)
      end
    else
      raise ArgumentError, "Could not parse object of type: <#{string.class}>."
    end

    result = collapse(@doc.root)
    result
  end

  # This is the functional version of the instance method xml_in.
  def XmlShit.xml_in(string)
    xml_shit = XmlShit.new
    xml_shit.xml_in(string)
  end

  # Converts a data structure into an CSV document
  #
  # ref::
  #   Reference to data structure to be converted into CSV
  def csv_out(ref, headers)
    csv_string = CSV.generate(write_headers: true, headers: headers, force_quotes: true) do |csv|
      ref.each do |h|
        row = h.values_at(*headers)
        csv << row
      end
    end
  end


  # This is the functional version of the instance method csv_out.
  def XmlShit.csv_out(ref, headers)
    xml_shit = XmlShit.new
    xml_shit.csv_out(ref, headers)
  end

  # Converts a CSV into a XML
  #
  # xml::
  #   exising xml data
  # csv::
  #   CSV data to be converted into XML
  # xpath_column::
  #   name of the column that contains xpath
  # langs::
  #   and array of columns name that contain language names
  #
  def xml_out(csv, xml, xpath_column, langs)
    unless csv.is_a?(CSV)
      raise ArgumentError, "Could not parse CSV object of type: <#{string.class}>."
    end
    unless xml.is_a?(REXML::Document)
      raise ArgumentError, "Could not parse XML object of type: <#{string.class}>."
    end

    csv.each do |row|
      xpath = row[xpath_column]
      node = REXML::XPath.first(xml, xpath)
      langs.each do |lang|
        unless row[lang].nil? || row[lang].empty?
          unless node.elements[lang].nil?
            node.delete_element(lang)
          end
          e = REXML::Element.new(lang)
          e.add_text(row[lang])
          node.add_element(e)
        end
      end
    end

    return xml
  end

  # This is the functional version of the instance method xml_out.
  def XmlShit.xml_out(csv, xml, xpath, langs)
    xml_shit = XmlShit.new
    xml_shit.xml_out(csv, xml, xpath, langs)
  end

  private

  # Actually converts an XML document element into a data structure.
  # element::
  #   The document element to be collapsed.
  def collapse(element, identifier = '', xpath = '', ary = [])
    attributes = get_attributes(element)

    if element.has_elements?
      attrs = attributes.inject([]) { |xpath, (k, v)| xpath << "#{k}='#{v}'" }.join(',')
      vals = attributes.inject([]) { |identifier, (_, v)| identifier << v }.join(',')

      xpath += "/#{element.name}[#{attrs}]"
      identifier += "/#{vals}"

      element.each_element do |child|
        value = collapse(child, identifier, xpath, ary) # \..\ ^_^ /../ recursion
      end
    elsif element.has_text? # i.e. it has only text.
      unless ary.find { |h| h['none'] == xpath }
        ary << { 'identifier' => identifier, 'none' => xpath }
      end

      lang = element.name
      if lang == 'English'
        ary.find { |h| h['none'] == xpath }['source_phrase'] = element.text
      else
        ary.find { |h| h['none'] == xpath }[lang] = element.text
      end

    end

    return ary
  end

  # Converts the attributes array of a document node into a Hash.
  # Returns an empty Hash, if node has no attributes.
  #
  # node::
  #   Document node to extract attributes from.
  def get_attributes(node)
    attributes = {}
    node.attributes.each { |n, v| attributes["@" + n] = v }
    attributes
  end


  # Parses an XML string and returns the according document.
  #
  # xml_string::
  #   XML string to be parsed.
  #
  # The following exception may be raised:
  #
  # REXML::ParseException::
  #   If the specified file is not wellformed.
  def parse(xml_string)
    REXML::Document.new(xml_string)
  end

end


if __FILE__ == $0
  xmlfile_name = 'strings.xml'
  xmlfile = File.open(xmlfile_name)

  string = xmlfile.read
  string.gsub!('&', '&amp;')

  xml_data = XmlShit.xml_in(string) #< array of hashes

  ## Crowdin multicolumn CSV
  scheme = "none,identifier,source_phrase,uk,ru"
  csv_file = 'strings.csv'
  ##

=begin
  # write CSV
  headers = scheme.split(',')

  csv = XmlShit.csv_out(xml_data, headers)

  File.open(csv_file, 'w') { |f| f.write(csv) }
=end

=begin
  # write XML
  scheme = "none,identifier,source_phrase,Ukrainian,Russian"
  _, _, _, *langs = scheme.split(',')

  xmlfile = File.open('strings.xml')
  xmldoc = REXML::Document.new(string)

  csv = CSV.open('strings.csv', headers: true)

  xmldoc = XmlShit.xml_out(csv, xmldoc, xpath_column = 'none', langs)

  # write xml
  File.open('strings.xml', 'w') do |xml_file|
    xml_file << xmldoc
  end
=end

end
