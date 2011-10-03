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
    
  end    
end