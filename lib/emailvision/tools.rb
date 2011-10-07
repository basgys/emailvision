module Emailvision  
  class Tools
    
    def self.r_camelize(obj)
      if obj.is_a?(Hash)
        new_obj = {}
        obj.each do |key, value|
          new_obj[key.to_s.camelize(:lower).to_sym] = r_camelize value
        end
        new_obj
      elsif obj.is_a?(Array)
        new_obj = []
        obj.each_with_index do |item, index|
          new_obj[index] = r_camelize item
        end
        new_obj
      else
        obj
      end
    end
    
    def self.to_xml_as_is(obj)
      obj_xml = ""
      xml = Builder::XmlMarkup.new(:target=> obj_xml)
      xml.instruct! :xml, :version=> "1.0"
            
      tag_obj xml, obj
      
      obj_xml
    end
    
    private
    
    def self.tag_obj(xml, obj)
      if obj.is_a? Hash
        obj.each do |key, value|
          if value.is_a?(Hash)            
            eval(%{
              xml.#{key} do
                tag_obj(xml, value)
              end
            })
          elsif value.is_a?(Array)
            value.each do |item|
              eval(%{
                xml.#{key} do
                  tag_obj(xml, item)
                end
              })
            end
          else
            eval %{xml.#{key}(%{#{value}})}
          end
        end
      else
        obj
      end
    end
    
  end    
end