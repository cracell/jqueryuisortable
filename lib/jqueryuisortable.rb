module JQueryUISortable
  def self.included(base)
    base.send :extend, ClassMethods
  end
 
  module ClassMethods
    def jquery_ui_sortable(options = {})
      cattr_accessor :scope
      self.scope = options[:scope]
      send :include, InstanceMethods
    end
  end
 
  module InstanceMethods
    def self.included(base)
      base.class_eval do
        before_create :set_position
      end
    end
    
    def set_position
      conditions = {}
      conditions.merge!({self.class.scope => self.send(self.class.scope)}) if self.class.scope.present?
      max = AboutUsQuestion.maximum("position", :conditions => conditions)
      self.position = max ? (max + 1) : 1
    end
 
    private :set_position
  end
end

ActiveRecord::Base.send :include, JQueryUISortable