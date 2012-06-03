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
  def add_url; send("#{@permissions_name}s_path") ; end
  def copy_url; edit_url; end # TODO : same as edit for now
  def form_path; send("#{@permissions_name}_path", :id => @permissions_object.id); end
  def additional_column_id(i); "ac#{i}_#{@permissions_object.id}"; end

  def permissions_sections
    # send("BONK_#{@permissions_name}")
    { 'role'     => [ 'Tabs',
                      'Admin',
                      'Dealer Admin',
                      'Corporate Admin',
                      'Brand Admin',
                      'Merchant Admin'
                    ],
      'products' => [ 'Branch and Location Portals : Settings',
                      'Branch and Location Portals : Social Media',
                      'Branch and Location Portals : Web Page',
                      'Solutions'
                    ]
    }[@permissions_name] # ugghhh : not working in helpers...
  end
  
  def models_that_have_permission
    mthp = @permissions_group_list.select{|p| p.permissions[@permission[:key]] }.collect(&:name).sort.reverse.join(', ')
    mthp.blank? ? 'none' : mthp
  end
  
  def copy_name
    "#{@permissions_object.name} copy"
  end

  def destroy_message
    "#{permissions_group.size} #{@permissions_header}#{permissions_group.size == 1 ? '' : 's'}<br/><div style='color:green; font-size:0.5em;'>'#{@permissions_object.name}' deleted</div>"
  end
  
  ##### RJS stuff : ughhh... TODO : determine what is needed...
  def set_page_tag(page, model) ; @page = page ; @page_model = model ; set_tag(model) ; end
  def set_tag(model); @tag = "_#{model.class.name.titleize.downcase.gsub(' ','_')}_#{model.id}"; end
  def data_tag ; tag_for 'data'; end
  def delete_tag ; tag_for 'delete'; end
  def errors_tag ; tag_for 'errors' ; end
  def email_status_tag ; tag_for 'email_status'; end
  def tag_for(t); "#{t}#{@tag}"; end
  def update_list_header(header_partial, header_id=header_partial)
    updated_header = render(:partial => header_partial)
    @page.call '$("#' + header_id + '").html( "' + escape_javascript(updated_header) + '" );fixme'
  end

  def set_page_tag_and_highlight_data(page, model)
    set_page_tag(page, model)
    @page.visual_effect :highlight, data_tag,  :duration => 1
  end

  def highlight_row_and_clear_add_form(table_id, add_errors_id, name_field_id)
    insert_row_and_clear_add_form(table_id, add_errors_id, name_field_id)
    @page.visual_effect :highlight, data_tag,  :duration => 2
    case name_field_id
    when /create_email/
      @page['#noticeExplanation'].replace_html('<h2>We will send a confirmation email to the address you entered. Click on the link in the email to activate the address and add it to your list.</h2>')
      show_flash_notice_message
      hide_flash_success_message
      @page.show "add_email_address"
      @page.hide "create_new_email"
    when /create_keyword/
      @page['#successExplanation'].replace_html('<h2>The keyword has been added.</h2>')
      hide_flash_notice_message
      show_flash_success_message
    end
  end

  def hide_flash_error_message
    @page.hide "errorExplanation"
  end

  def hide_flash_success_message
    @page.hide "successExplanation"
  end

  def hide_flash_notice_message
    @page.hide "noticeExplanation"
  end

  def show_flash_error_message
    @page.show "errorExplanation"
  end

  def show_flash_success_message
    @page.show "successExplanation"
  end

  def show_flash_notice_message
    @page.show "noticeExplanation"
  end

  def insert_row_and_clear_add_form(table_id, add_errors_id, name_field_id, row_partial='row')
    @page.call '$("' + table_id + '").append("' + escape_javascript(render(:partial => row_partial)) + '"); fixme'
    # @page.insert_html :bottom, table_id, :partial => row_partial
    @page.hide add_errors_id
    @page[name_field_id].value = ''
  end

  def wrap_up_copy
    from_id = @permissions_object.from
    @page.call '$("#copy_form_' + from_id + '").hide();fixme'
    @page.call '$("#copy_link_' + from_id + '").show();fixme'
  end

  def show_errors(error_id, field_id)
    error_id = '#' + error_id + '_errors'
    @page.replace_html error_id, h(truncate(@response_message, 253, "..."))
    @page.show error_id
    @page.visual_effect :highlight, error_id.delete('#'),  :duration => 2
    @page[field_id].focus.select
  end

  def show_model_errors
    @page[errors_tag].replace_html h(truncate(@page_model.errors.full_messages.join(' '), 253, "..."))
    @page.show errors_tag
    @page.visual_effect :highlight, errors_tag,  :duration => 1
  end

  def update_list_header_and_animate_delete(header_partial, delete_id_tags=[], header_id=header_partial)
    update_list_header header_partial, header_id
    animate_delete header_partial, delete_id_tags
  end

  def animate_delete(header_partial='', id_tags=[])
    @page[delete_tag].replace_html '<span style="color:red"><b>DELETED</b></span>'
    case header_partial
    when ''
      @page['#successExplanation'].replace_html('<h2>This email address has been deleted.</h2>')
    when /keyword_count/
      @page['#successExplanation'].replace_html('<h2>The keyword has been deleted.</h2>')
    end
    @page.delay(1.5) { ([data_tag, errors_tag] + id_tags).each {|id_tag| @page[id_tag].prev().prev().remove;@page[id_tag].prev().remove;@page[id_tag].remove} }
    show_flash_success_message
    hide_flash_notice_message
  end

  def edit_model(list_id, form_id, field_id, form_partial = 'form')
    @page.hide list_id
    @page.replace_html form_id, :partial => form_partial
    @page.show form_id
    @page[field_id].focus.select
  end

end
