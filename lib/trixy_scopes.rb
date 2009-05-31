module TrixyScopes 

  def self.included(klass)
    klass.class_eval do
      table_name = klass.quoted_table_name
     
      named_scope :limit, lambda { |limit| { :limit => limit } }
      named_scope :latest, lambda { |limit| { :limit => limit, :order => "#{table_name}.`created_at` desc" } } 
      named_scope :earliest, lambda { |limit| { :limit => limit, :order => "#{table_name}.`created_at` asc" } }
      named_scope :before, lambda { |datetime| { :conditions => ["#{table_name}.`created_at` < ?", datetime] } }
      named_scope :after, lambda { |datetime| { :conditions => ["#{table_name}.`created_at` > ?", datetime] } }
      named_scope :in, lambda { |*ids| { :conditions => {:id => ids.flatten } } }
      named_scope :not_in, lambda { |*ids| { :conditions => ["#{table_name}.`id` NOT IN(?)", ids.flatten] } }
      
      klass.columns.each do |column|
        quoted_column_name = ActiveRecord::Base.connection.quote_table_name("#{klass.table_name}.#{column.name}")
  
        named_scope "#{column.name}_is", lambda { |value| { :conditions => { column.name => value } } }
        named_scope "#{column.name}_is_not", lambda { |value| { :conditions => ["#{quoted_column_name} != ?", value] } }
        named_scope "#{column.name}_is_nil", :conditions => { column.name => nil }
        named_scope "#{column.name}_is_not_nil", :conditions => "#{quoted_column_name} IS NOT NULL"
        
        unless column.type == :boolean
          named_scope "#{column.name}_between", lambda { |from, to| { :conditions => ["#{quoted_column_name} BETWEEN ? AND ?", from, to] } }
          named_scope "#{column.name}_not_between", lambda { |from, to| { :conditions => ["#{quoted_column_name} NOT BETWEEN ? AND ?", from, to] } }
        end
        
        unless column.type == :boolean || column.type == :text
          named_scope "#{column.name}_in", lambda { |*elements| { :conditions => { column.name => elements.flatten } } }
          named_scope "#{column.name}_not_in", lambda { |*elements| { :conditions => ["#{quoted_column_name} NOT IN(?)", elements.flatten] } }
        end
                
        if column.type == :datetime
          named_scope "#{column.name}_before", lambda { |datetime| { :conditions => ["#{quoted_column_name} < ?", datetime] } }
          named_scope "#{column.name}_after", lambda { |datetime| { :conditions => ["#{quoted_column_name} > ?", datetime] } }
          
          if column.name.last(3) == "_at"
            column_name_alias = column.name.chomp("_at")
            named_scope "#{column_name_alias}_between", lambda { |from, to| { :conditions => ["#{quoted_column_name} BETWEEN ? AND ?", from, to] } }
            named_scope "#{column_name_alias}_not_between", lambda { |from, to| { :conditions => ["#{quoted_column_name} NOT BETWEEN ? AND ?", from, to] } }
            named_scope "#{column_name_alias}_before", lambda { |datetime| { :conditions => ["#{quoted_column_name} < ?", datetime] } }
            named_scope "#{column_name_alias}_after", lambda { |datetime| { :conditions => ["#{quoted_column_name} > ?", datetime] } }
          end
        end
        
        if column.type == :integer || column.type == :float
          named_scope "#{column.name}_greater_than", lambda { |value| { :conditions => ["#{quoted_column_name} > ?", value] } }
          named_scope "#{column.name}_greater_or_equal_to", lambda { |value| { :conditions => ["#{quoted_column_name} >= ?", value] } }
          named_scope "#{column.name}_less_than", lambda { |value| { :conditions => ["#{quoted_column_name} < ?", value] } }
          named_scope "#{column.name}_less_or_equal_to", lambda { |value| { :conditions => ["#{quoted_column_name} <= ?", value] } }
        end
        
        if column.type == :string
          named_scope "#{column.name}_starts_with", lambda { |string| { :conditions => ["#{quoted_column_name} LIKE ?", "#{string}%"] } }
          named_scope "#{column.name}_ends_with", lambda { |string| { :conditions => ["#{quoted_column_name} LIKE ?", "%#{string}"] } }
          named_scope "#{column.name}_includes", lambda { |string| { :conditions => ["#{quoted_column_name} LIKE ?", "%#{string}%"] } }
          named_scope "#{column.name}_matches", lambda { |regexp| { :conditions => ["#{quoted_column_name} REGEXP ?", regexp] } }
        end
        
        if column.type == :text || column.type == :string
          named_scope "#{column.name}_like", lambda { |string| { :conditions => ["#{quoted_column_name} LIKE ?", string] } }
          named_scope "#{column.name}_not_like", lambda { |string| { :conditions => ["#{quoted_column_name} NOT LIKE ?", string] } }
        end
        
        if column.type == :boolean
          named_scope "#{column.name}", :conditions => { column.name => true }
          named_scope "not_#{column.name}", :conditions => { column.name => false }
        end
      end
      
    end
  end

end
