module TrixyScopes 

  def self.included(klass)
    klass.class_eval do
      table_name = klass.table_name
      
      named_scope :limit, lambda { |limit| { :limit => limit } }
      named_scope :latest, lambda { |limit| { :limit => limit, :order => "`#{table_name}`.`created_at` desc" } } 
      named_scope :earliest, lambda { |limit| { :limit => limit, :order => "`#{table_name}`.`created_at` asc" } }
      named_scope :before, lambda { |datetime| { :conditions => ["`#{table_name}`.`created_at` < ?", datetime] } }
      named_scope :after, lambda { |datetime| { :conditions => ["`#{table_name}`.`created_at` > ?", datetime] } }
      named_scope :in, lambda { |*ids| { :conditions => {:id => ids.flatten } } }
      named_scope :not_in, lambda { |*ids| { :conditions => ["`#{table_name}`.`id` NOT IN(?)", ids.flatten] } }
      
      klass.columns.each do |column|
        attribute = column.name
        sanitized_attribute = `#{table_name}`.`#{attribute}`
  
        named_scope "#{attribute}_is", lambda { |value| { :conditions => { attribute => value } } }
        named_scope "#{attribute}_is_not", lambda { |value| { :conditions => ["#{sanitized_attribute} != ?", value] } }
        named_scope "#{attribute}_is_nil", :conditions => { attribute => nil }
        named_scope "#{attribute}_is_not_nil", :conditions => "#{sanitized_attribute} IS NOT NULL"
        
        unless column.type == :boolean
          named_scope "#{attribute}_between", lambda { |from, to| { :conditions => ["#{sanitized_attribute} BETWEEN ? AND ?", from, to] } }
          named_scope "#{attribute}_not_between", lambda { |from, to| { :conditions => ["#{sanitized_attribute} NOT BETWEEN ? AND ?", from, to] } }
        end
        
        unless column.type == :boolean || column.type == :text
          named_scope "#{attribute}_in", lambda { |*elements| { :conditions => { attribute => elements.flatten } } }
          named_scope "#{attribute}_not_in", lambda { |*elements| { :conditions => ["#{sanitized_attribute} NOT IN(?)", elements.flatten] } }
        end
                
        if column.type == :datetime
          named_scope "#{attribute}_before", lambda { |datetime| { :conditions => ["#{sanitized_attribute} < ?", datetime] } }
          named_scope "#{attribute}_after", lambda { |datetime| { :conditions => ["#{sanitized_attribute} > ?", datetime] } }
          
          if attribute.last(3) == "_at"
            attribute_alias = attribute.chomp("_at")
            named_scope "#{attribute_alias}_between", lambda { |from, to| { :conditions => ["#{sanitized_attribute} BETWEEN ? AND ?", from, to] } }
            named_scope "#{attribute_alias}_not_between", lambda { |from, to| { :conditions => ["#{sanitized_attribute} NOT BETWEEN ? AND ?", from, to] } }
            named_scope "#{attribute_alias}_before", lambda { |datetime| { :conditions => ["#{sanitized_attribute} < ?", datetime] } }
            named_scope "#{attribute_alias}_after", lambda { |datetime| { :conditions => ["#{sanitized_attribute} > ?", datetime] } }
          end
        end
        
        if column.type == :integer || column.type == :float
          named_scope "#{attribute}_greater_than", lambda { |value| { :conditions => ["#{sanitized_attribute} > ?", value] } }
          named_scope "#{attribute}_greater_or_equal_to", lambda { |value| { :conditions => ["#{sanitized_attribute} >= ?", value] } }
          named_scope "#{attribute}_less_than", lambda { |value| { :conditions => ["#{sanitized_attribute} < ?", value] } }
          named_scope "#{attribute}_less_or_equal_to", lambda { |value| { :conditions => ["#{sanitized_attribute} <= ?", value] } }
        end
        
        if column.type == :string
          named_scope "#{attribute}_starts_with", lambda { |string| { :conditions => ["#{sanitized_attribute} LIKE ?", "#{string}%"] } }
          named_scope "#{attribute}_ends_with", lambda { |string| { :conditions => ["#{sanitized_attribute} LIKE ?", "%#{string}"] } }
          named_scope "#{attribute}_includes", lambda { |string| { :conditions => ["#{sanitized_attribute} LIKE ?", "%#{string}%"] } }
          named_scope "#{attribute}_matches", lambda { |regexp| { :conditions => ["#{sanitized_attribute} REGEXP ?", regexp] } }
        end
        
        if column.type == :text || column.type == :string
          named_scope "#{attribute}_like", lambda { |string| { :conditions => ["#{sanitized_attribute} LIKE ?", string] } }
          named_scope "#{attribute}_not_like", lambda { |string| { :conditions => ["#{sanitized_attribute} NOT LIKE ?", string] } }
        end
        
        if column.type == :boolean
          named_scope "#{attribute}", :conditions => { attribute => true }
          named_scope "not_#{attribute}", :conditions => { attribute => false }
        end
      end
      
    end
  end

end
