  class TlfValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      record.errors[attribute] << (options[:message] || "no tiene formato de número telefónico") unless
      value =~ /(\d{4})-(\d{6,})/
    end
  end
  
  
