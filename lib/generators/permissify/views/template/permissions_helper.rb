module PermissionsHelper
  def set_tag(model); @tag = "_#{model.class.name.titleize.downcase.gsub(' ','_')}_#{model.id}"; end
  def data_tag ; tag_for 'data'; end
  def tag_for(t); "#{t}#{@tag}"; end
  def delete_tag ; tag_for 'delete'; end
  def product_permissions; @permissions ||= Ability.all_for(@applicability); end  
  def section_categories
    section_permissions = product_permissions.select{|permission| permission[:section] == @section }
    section_permissions.collect{|sp| sp[:category]}.uniq.sort
  end
  def permissions_group; @permissions_group_list ||= @permissions_class.find(:all, :order => "#{@permissions_class.table_name}.#{@sort_field} ASC"); end
  def permissions_group_name ; truncate(@permissions_object.name, :length => 40) ; end
  def status_tag ; tag_for 'status' ; end
  def edit_tag ; tag_for 'edit' ; end
  def colorized_permission; @permissions_object.allows?(@permission[:key]) ? 'green' : 'red' ; end
  def category_permissions
    return @category_permissions if @category == @last_category
    @last_category = @category
    @category_permissions = @permissions.select{|pa| pa[:category] == @category}
    @category_permissions.sort!{|pa1,pa2| pa1[:position] <=> pa2[:position]}
  end
  def category_name; 'category_' + @category.downcase.gsub(' ', '_'); end
  
  def permission_click_actions
    actions = category_allows_one_or_none ? clear_all_in_category : click_associated_checkbox
    actions += expand_category + focus_and_select_first_additional_input if @permission[:number_of_values] > 1
    actions
  end
  
  def category_allows_one_or_none
    @permission[:category_allows] == :one_or_none
  end
  def clear_all_in_category
    "clear_all_in_category(this, '#{@permissions_prefix}');"
  end
  def click_associated_checkbox
    "toggle_color_coded_permission('#{@permission[:key]}', document.getElementById('#{@permissions_prefix}permissions_#{@permission[:key]}_0'));"
  end
  def expand_category ; "$('##{category_name}').show();" ; end
  def focus_and_select_first_additional_input ; "$('##{@permissions_prefix}permissions_#{@permission[:key]}_1').focus().select()" ; end
  
  def permission_values
    @permission[:administration_expression].split('**').collect{|@token| permission_token }.join('')
  end
  
  def permission_token
    @token.starts_with?('*') ? permission_input(@token.delete('*').split(':')) : @token
  end
  
  def permission_input(specification)
    permission_text_input(specification) if specification[1] == 'text'
  end
  
  def permission_text_input(specification)
    size  = specification[2].to_i
    size  = 4 if size == 0
    value = (@permissions_object.permissions[@permission[:key]][specification[0]] rescue nil)
    value = @permission[:default_values][specification[0].to_i] if value.blank?
    name  = "#{@permissions_name}[permissions][#{@permission[:key]}][#{specification[0]}]"
    id    = "#{@permissions_prefix}permissions_#{@permission[:key]}_#{specification[0]}"
    "<input type='text' id='#{id}' name='#{name}' value='#{value}' size='#{size}' maxlength='#{size}'/>"
  end

  def edit_url; send("edit_#{@permissions_name}_url", :id => @permissions_object); end
  def form_path; send("#{@permissions_name}_path", :id => @permissions_object.id); end
  def additional_column_id(i); "ac#{i}_#{@permissions_object.id}"; end

  def permissions_sections
    { 'role'     => [ 'Tabs',
                      'Admin',
                      'Dealer Admin',
                      'Corporation Admin',
                      'Brand Admin',
                      'Merchant Admin'
                    ],
      # 'products' => [ 'Branch and Location Portals : Settings',
      #                 'Branch and Location Portals : Social Media',
      #                 'Branch and Location Portals : Web Page',
      #                 'Solutions'
      #               ]
    }[@permissions_name]
  end
  
  def models_that_have_permission
    mthp = @permissions_group_list.select{|p| p.permissions[@permission[:key]] }.collect(&:name).sort.reverse.join(', ')
    mthp.blank? ? 'none' : mthp
  end
  
end
