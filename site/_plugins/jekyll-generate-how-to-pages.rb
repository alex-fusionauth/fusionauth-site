require 'net/http'
require 'uri'
require 'json'
require 'rss'
require 'nokogiri'
require 'date'

module Jekyll
  class HowToPagesGenerator < Generator

    def generate(site)
      techs = site.data['technologies']
      operations = site.data['operations']
      output_dir = "#{site.source}/how-tos/"
      input_dir = "#{site.source}/_how-to-source/"

      techs.each do |tech|
        #puts "processing: " +tech['name']
        operations.each do |operation|
          #puts "processing: " +operation['name']

          file_name = build_file_name(tech,operation)
          title = build_title(tech,operation)

          # could optimize and cache these values, but for now, read them every time
          tech_fragment_file_location = input_dir+"/technologies/"+tech['contentFileName']
          tech_fragment_file = File.open(tech_fragment_file_location,"r")
          
          operation_fragment_file_location = input_dir+"/operations/"+operation['contentFileName']
          operation_fragment_file = File.open(operation_fragment_file_location,"r")

          # Check if the file needs to be re-generated
          output = File.join(output_dir, file_name)
          #if !File.exist?(output)
            File.open(output_dir+file_name, "w") do |f| 
               f.write get_header(title, tech,operation)
               f.write tech_fragment_file.read
               f.write operation_fragment_file.read
            end
            site.static_files << Jekyll::StaticFile.new(site, '', output_dir, file_name)
          #end
        end
      end
  
    end

    def build_file_name(tech,operation)
      return "how-to-" + operation['urlName'] + "-using-" + tech['urlName'] + ".md"
    end

    def build_title(tech,operation)
      return "How to " + operation['name'] + " for your " + tech['name'] + " application "
    end

    def get_header(title,tech,operation)
      header = <<-END
---
layout: blog-post
title: #{title}
description: #{title}
---
END
    end
  end
end
