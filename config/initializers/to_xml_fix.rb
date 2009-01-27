# ActiveRecord::Base.class_eval <<-CODE
# def self.to_s
#   class_name
# end
# CODE
# #   # raise self
# #   # self.abstract_class = true
# # 
# #   # ActiveRecord has a bug where it produces invalid xml when serializing scoped 
# #   # objects. I have submited a bug fix for this but for now this is the easiest 
# #   # solution i can think of. 
# #   def self.to_s
# #     class_name
# #   end
# #   # 
# # end