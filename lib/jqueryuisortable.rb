require File.join(File.dirname(__FILE__), "railtie")

module JQueryUISortable
  def self.included(base)
    base.send :extend, ClassMethods
  end
 
  module ClassMethods
    def jquery_ui_sortable(options = {})
      cattr_accessor :column
      self.column = options[:column]
      send :include, InstanceMethods
    end
    
    def update_positions(ids, conditions)
      ids.each_with_index do |id, index|
        if record = self.find(id, conditions)
          record.update_attribute(:position, (index + 1))
        end
      end
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
      conditions.merge!({self.class.column => self.send(self.class.column)}) if self.class.column.present?
      max = AboutUsQuestion.maximum("position", :conditions => conditions)
      self.position = max ? (max + 1) : 1
    end
 
    private :set_position
  end
end

ActiveRecord::Base.send :include, JQueryUISortable