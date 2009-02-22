# Used to add data from arrays of information
module RestlessForms 
  # This will add a contained star to the document if the given field is true
  def output_error( bool, css_name = 'form_error' )
    return (bool)? "<div class=\"#{css_name}\">*</div>": ''
  end

  # Output the object like dumb form but with divs
  def dump_data( model, form_var, obj, css_name = '',
                except = [], only = nil, 
                human_names = {}, special = {} )
    return dump_form( model, form_var, obj, css_name, except, only, 
                human_names, special, true )
  end


  # This will dump the controls that surround whatever model a user passed
  # The user also has the ability to limit which files are show
  def dump_form( model, form_var, obj, css_name = '',
                except = [], only = nil, 
                human_names = {}, special = {}, no_control = false )

    output = "<div class=\"#{css_name}container\">\n"

      #If no only list was given, then make my own from the model
    if only.nil?
      only = model.columns.sort{|a, b|a.name<=>b.name}.collect{|x|x.name.to_sym}
    end

      #Convert my except string into a hash for quick access
    remove = Hash.new
    except = [except] if !except.is_a? Array
    [except, [:id, :created_at, :updated_at]].flatten.each {|e| remove[e]=true }

      #Make sure my only variable is an array
    only = [only] if !only.is_a? Array

      #Make a hash of my model we're working with
    columns = Hash.new
    model.columns.each { |c| columns[c.name.to_sym] = c }

      #Go through my only list and output all the controls
    only.each do |col|  
      if !remove.has_key?(col) and !(col.to_s =~ /_id$/)
        output += "<div class=\"#{css_name}#{col}\">"
        output += "<label>#{human_names[col] || "#{model.to_s}'s #{col.to_s.split(/_/).collect{|x| x.capitalize}.join(' ')}"}"
        
          #Based on the column type, output a form field
        case columns[col].type
        when :string
          if columns[col].name =~ /password/i or columns[col].name =~ /passwd/i
            output += password_field form_var, col.to_s,special[col]||{ :value => obj.send(col) } if !no_control
          elsif !no_control
            output +=  text_field form_var, col.to_s, special[col] || { :value => obj.send(col) } 
          elsif no_control
            output +=  "<div>#{obj.send(col)}</div>" 
          end
        when :datetime
        when :integer
          if !no_control
            output +=  text_field form_var, col.to_s, special[col] || { :value => obj.send(col) }
          else
            output +=  "<div>#{obj.send(col)}</div>" 
          end
        when :boolean
        when :text
        else
        end

        output += "</label></div>\n"
      end
    end

      #Close off my container div
    output += "</div>\n"

    return output
  end

  # Create hooks into action view that gives the user access to the current_user
  def self.included(base)
    base.send :helper_method, :output_error, :dump_data, :dump_form if base.respond_to? :helper_method
  end
end
