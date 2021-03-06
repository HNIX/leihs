# -*- encoding : utf-8 -*-

Wenn(/^man sich auf der Modellliste befindet$/) do
  @category = Category.first
  visit borrow_models_path(category_id: @category.id)
end

Wenn(/^man sich auf der Modellliste befindet die verfügbare Modelle beinhaltet$/) do
  @category = Category.find do |c|
    c.models.any? { |m| m.availability_in(@current_user.inventory_pools.first).maximum_available_in_period_summed_for_groups(Date.today, Date.today, @current_user.group_ids) >= 1 }
  end
  visit borrow_models_path(category_id: @category.id)
end

Wenn(/^man sich auf der Modellliste befindet die nicht verfügbare Modelle beinhaltet$/) do
  @start_date ||= Date.today
  @end_date ||= Date.today+1.day
  model = @current_user.models.borrowable.detect do |m|
    quantity = @current_user.inventory_pools.to_a.sum do |ip|
      m.availability_in(ip).maximum_available_in_period_summed_for_groups(@start_date, @end_date, @current_user.groups.map(&:id))
    end
    quantity <= 0 and not m.categories.blank?
  end
  @category = model.categories.first
  visit borrow_models_path(category_id: @category.id)
  within "#model-list-search" do
    find("input").click
    find("input").set model.name
  end
end

Dann(/^sind alle Geräteparks ausgewählt$/) do
  within "#ip-selector" do
    all(".dropdown-item input").all? &:checked?
  end
end

Dann(/^die Modellliste zeigt Modelle aller Geräteparks an$/) do
  within "#model-list" do
    expect(@current_user.models.borrowable.from_category_and_all_its_descendants(@category.id).default_order.paginate(page: 1, per_page: 20).map(&:name)).to eq all(".text-align-left").map(&:text)
  end
end

Dann(/^im Filter steht "(.*?)"$/) do |button_label_de|
  within "#ip-selector" do
    find(".button", text: button_label_de)
  end
end

Angenommen(/^man befindet sich auf der Modellliste$/) do
  step "man sich auf der Modellliste befindet"
end

Wenn(/^man ein bestimmten Gerätepark in der Geräteparkauswahl auswählt$/) do
  find("#ip-selector").click
  expect(has_selector?("#ip-selector .dropdown .dropdown-item", :visible => true)).to be true
  @current_inventory_pool ||= @current_user.inventory_pools.first
  find("#ip-selector .dropdown .dropdown-item", text: @current_inventory_pool.name).click
end

Dann(/^sind alle anderen Geräteparks abgewählt$/) do
  find("#ip-selector").click
  (@current_user.inventory_pools - [@current_inventory_pool]).each do |ip|
    expect(find("#ip-selector .dropdown-item", text: ip.name).find("input", match: :first).checked?).to be false
  end
end

Dann(/^die Modellliste zeigt nur Modelle dieses Geräteparks an$/) do
  within "#model-list" do
    expect(all(".text-align-left").map(&:text).reject{|t| t.empty?}).to eq @current_user.models.borrowable
                                                                           .from_category_and_all_its_descendants(@category.id)
                                                                           .by_inventory_pool(@current_inventory_pool.id)
                                                                           .default_order.paginate(page: 1, per_page: 20)
                                                                           .map(&:name)
  end
end

Dann(/^die Auswahl klappt zu$/) do
  expect(find("#ip-selector .dropdown").visible?).to be false
end

Dann(/^im Filter steht der Name des ausgewählten Geräteparks$/) do
  expect(has_selector?("#ip-selector .button", text: @current_inventory_pool.name)).to be true
end

Wenn(/^man einige Geräteparks abwählt$/) do
  find("#ip-selector").click
  @current_inventory_pool = @current_user.inventory_pools.first
  @dropdown_element = find("#ip-selector .dropdown")
  @dropdown_element.find(".dropdown-item", match: :first, text: @current_inventory_pool.name).find("input", match: :first).click
end

Dann(/^wird die Modellliste nach den übrig gebliebenen Geräteparks gefiltert$/) do
  within "#model-list" do
    expect(has_selector?(".text-align-left")).to be true
    expect(all(".text-align-left").map(&:text)).to eq @current_user.models.borrowable
                                                      .from_category_and_all_its_descendants(@category.id)
                                                      .all_from_inventory_pools(@current_user.inventory_pool_ids - [@current_inventory_pool.id])
                                                      .default_order
                                                      .paginate(page: 1, per_page: 20)
                                                      .map(&:name)
  end
end

Dann(/^wird die Modellliste nach dem übrig gebliebenen Gerätepark gefiltert$/) do
  within "#model-list" do
    expect(has_selector?(".text-align-left")).to be true
    expect(all(".text-align-left").map(&:text).reject{|t| t.empty?}[0..20]).to eq @current_user.models.borrowable
                                                                                  .from_category_and_all_its_descendants(@category.id)
                                                                                  .all_from_inventory_pools(@current_user.inventory_pool_ids - @ips_for_unselect.map(&:id))
                                                                                  .default_order
                                                                                  .paginate(page: 1, per_page: 20)
                                                                                  .map(&:name)
  end
end

Dann(/^die Auswahl klappt noch nicht zu$/) do
  expect(find("#ip-selector .dropdown").visible?).to be true
end

Wenn(/^man alle Geräteparks bis auf einen abwählt$/) do
  find("#ip-selector").click
  @current_inventory_pool = @current_user.inventory_pools.first
  @ips_for_unselect = @current_user.inventory_pools.where("inventory_pools.id != ?", @current_inventory_pool.id)
  @ips_for_unselect.each do |ip|
    find("#ip-selector .dropdown-item", text: ip.name).find("input", match: :first).click
  end
end

Dann(/^im Filter steht der Name des übriggebliebenen Geräteparks$/) do
  find("#ip-selector .button", text: @current_inventory_pool.name)
end

Dann(/^kann man nicht alle Geräteparks in der Geräteparkauswahl abwählen$/) do
  find("#ip-selector").click
  within "#ip-selector" do
    inventory_pool_ids = all(".dropdown-item[data-id]").map{|item| item["data-id"]}
    inventory_pool_ids.each do |ip_id|
      expect(has_selector?(".dropdown .dropdown-item", visible: true)).to be true
      find(".dropdown-item[data-id='#{ip_id}']").click
    end
    expect(has_selector?(".dropdown-item input:checked")).to be true
  end
end

Dann(/^ist die Geräteparkauswahl alphabetisch sortiert$/) do
  within "#ip-selector" do
    expect(all(".dropdown-item[data-id]").map(&:text)).to eq @current_user.inventory_pools.order("inventory_pools.name").map(&:name)
  end
end

Dann(/^im Filter steht die Zahl der ausgewählten Geräteparks$/) do
  number_of_selected_ips = (@current_user.inventory_pool_ids - [@current_inventory_pool.id]).length
  find("#ip-selector .button", text: (number_of_selected_ips.to_s + " " + _("Inventory pools")))
end

Wenn(/^man die Liste nach "(.*?)" sortiert$/) do |sort_order|
  find("#model-sorting").click
  text = case sort_order
    when "Modellname (alphabetisch aufsteigend)"
      "#{_("Model")} (#{_("ascending")})"
    when "Modellname (alphabetisch absteigend)"
      "#{_("Model")} (#{_("descending")})"
    when "Herstellername (alphabetisch aufsteigend)"
      "#{_("Manufacturer")} (#{_("ascending")})"
    when "Herstellername (alphabetisch absteigend)"
      "#{_("Manufacturer")} (#{_("descending")})"
  end
  find("#model-sorting a", text: text).click
  find("#model-list .line", match: :first)
end

Dann(/^ist die Liste nach "(.*?)" "(.*?)" sortiert$/) do |sort, order|
  attribute = case sort
              when "Modellname"
                "name"
              when "Herstellername"
                "manufacturer"
              end
  direction = case order
              when "(alphabetisch aufsteigend)"
                "asc"
              when "(alphabetisch absteigend)"
                "desc"
              end
  within "#model-list" do
    expect(all(".text-align-left").map(&:text).reject{|t| t.empty?}).to eq @current_user.models.borrowable
                                                                           .from_category_and_all_its_descendants(@category.id)
                                                                           .order_by_attribute_and_direction(attribute, direction)
                                                                           .paginate(page: 1, per_page: 20)
                                                                           .map(&:name)
  end
end

Wenn(/^man ein Suchwort eingibt$/) do
  x = find("#model-list-search input")
  x.set " "
  x.set "bea panas"
  find("#model-list .line", :match => :first)
end

Dann(/^werden diejenigen Modelle angezeigt, deren Name oder Hersteller dem Suchwort entsprechen$/) do
  find("#model-list .line", text: /bea.*panas/i)
end

Dann(/^ist kein Ausleihzeitraum ausgewählt$/) do
  expect(find("#start-date").value).to eq nil
  expect(find("#end-date").value).to eq nil
end

Wenn(/^man ein Startdatum auswählt$/) do
  @start_date ||= Date.today
  find("#start-date").set I18n.l @start_date
  find(".ui-state-active").click
end

Dann(/^wird automatisch das Enddatum auf den folgenden Tag gesetzt$/) do
  @end_date ||= Date.today+1.day
  expect(find("#end-date").value).to eq I18n.l(@end_date)
end

Dann(/^die Liste wird gefiltert nach Modellen die in diesem Zeitraum verfügbar sind$/) do
  within "#model-list" do
    expect(has_selector?(".line[data-id]")).to be true
    all(".line[data-id]").each do |model_el|
      model = Model.find_by_id(model_el["data-id"]) || Model.find_by_id(model_el.reload["data-id"])
      expect(model).not_to be_nil
      quantity = @current_user.inventory_pools.to_a.sum do |ip|
        model.availability_in(ip).maximum_available_in_period_summed_for_groups(@start_date, @end_date, @current_user.groups.map(&:id))
      end
      if quantity <= 0
        @unavailable_model_found = true
        expect(model_el[:class]["grayed-out"]).to be
      else
        expect(model_el[:class]["grayed-out"]).not_to be
      end
    end
    expect(@unavailable_model_found).not_to be_nil
  end
end

Wenn(/^man ein Enddatum auswählt$/) do
  @end_date = Date.today + 1.day
  fill_in "end-date", with: (I18n.l @end_date)
end

Dann(/^wird automatisch das Startdatum auf den vorhergehenden Tag gesetzt$/) do
  sleep(0.55) # NOTE this sleep is required because waiting for onchange event
  @start_date = @end_date - 1.day
  expect(find("#start-date").value).to eq I18n.l(@start_date)
end

Angenommen(/^das Startdatum und Enddatum des Ausleihzeitraums sind ausgewählt$/) do
  step 'man ein Startdatum auswählt'
  step 'man ein Enddatum auswählt'
end

Wenn(/^man das Startdatum und Enddatum leert$/) do
  fill_in "start-date", with: ""
  fill_in "end-date", with: ""
end

Dann(/^wird die Liste nichtmehr nach Ausleihzeitraum gefiltert$/) do
  expect(has_no_selector?(".grayed-out")).to be true
end

Wenn(/^kann man für das Startdatum und für das Enddatum den Datepick benutzen$/) do
  find("#start-date").set I18n.l Date.today
  find(".ui-datepicker")
  find("#end-date").set I18n.l Date.today
  find(".ui-datepicker")
end

Dann(/^sieht man die Explorative Suche$/) do
  expect(has_selector?("#explorative-search")).to be true
  expect(has_selector?("#explorative-search a[href*='/models']")).to be true
end

Dann(/^man sieht die Modelle der ausgewählten Kategorie$/) do
  category = Category.find Rack::Utils.parse_nested_query(URI.parse(current_url).query)["category_id"]
  models = @current_user.models.borrowable.from_category_and_all_its_descendants(@category)
  within "#model-list" do
    all(".line[data-id]").each do |model_line|
      model = Model.find model_line["data-id"]
      expect(models.include? model).to be true
    end
  end
end

Dann(/^man sieht Sortiermöglichkeiten$/) do
  within "#model-sorting" do
    expect(has_selector?(".dropdown *[data-sort]", visible: false)).to be true
  end
end

Dann(/^man sieht die Gerätepark\-Auswahl$/) do
  within "#ip-selector" do
    expect(has_selector?(".dropdown", visible: false)).to be true
  end
end

Dann(/^man sieht die Einschränkungsmöglichkeit eines Ausleihzeitraums$/) do
  expect(has_selector?("#start-date")).to be true
  expect(has_selector?("#end-date")).to be true
end

Wenn(/^einen einzelner Modelleintrag beinhaltet$/) do |table|
  within "#model-list" do
    model_line = find(".line", match: :first)
    model = Model.find model_line["data-id"]
    table.raw.map{|e| e.first}.each do |row|
      case row
        when "Bild"
          model_line.find("img[src*='#{model.id}']", match: :first)
        when "Modellname"
          model_line.find(".line-col", match: :first, text: model.name)
        when "Herstellname"
          model_line.find(".line-col", match: :first, text: model.manufacturer)
        when "Auswahl-Schaltfläche"
          model_line.find(".line-col .button", match: :first)
        else
          raise "Unbekannt"
      end
    end
  end
end

Angenommen(/^man sieht eine Modellliste die gescroll werden muss$/) do
  @category = Category.all.find{|c| c.models.length > 20}
  visit borrow_models_path(category_id: @category.id)
end

Wenn(/^bis ans ende der bereits geladenen Modelle fährt$/) do
  page.execute_script %Q{ $($('.page')[1]).trigger('inview'); }
end

Dann(/^wird der nächste Block an Modellen geladen und angezeigt$/) do
  within "#model-list" do
    expect(all(".line").count).to be > 20
  end
end

Wenn(/^man bis zum Ende der Liste fährt$/) do
  find("footer").click
end

Dann(/^wurden alle Modelle der ausgewählten Kategorie geladen und angezeigt$/) do
  within "#model-list" do
    find(".line", match: :first)
    expect(all(".line").size).to eq @current_user.models.borrowable.from_category_and_all_its_descendants(@category).length
  end
end

Wenn(/^man über das Modell hovered$/) do
  find(".line[data-id='#{@model.id}']").hover
end

Dann(/^werden zusätzliche Informationen angezeigt zu Modellname, Bilder, Beschreibung, Liste der Eigenschaften$/) do
  within(".tooltipster-default") do
    find(".headline-s", text: @model.name)
    find(".paragraph-s", text: @model.description)
    @model.properties.take(5).each do |property|
      within(".row.margin-top-xs", text: property.key) do
        find(".col1of3", text: property.key)
        find(".col2of3", text: property.value)
      end
    end
    (0..@model.images.count-1).each do |i|
      expect(has_selector?("img[src*='/models/#{@model.id}/image_thumb?offset=#{i}']", :visible => false)).to be true
    end
  end
end

Angenommen(/^es gibt ein Modell mit Bilder, Beschreibung und Eigenschaften$/) do
  @model = @current_user.models.borrowable.find {|m| !m.images.blank? and !m.description.blank? and !m.properties.blank?}
end

Angenommen(/^man befindet sich auf der Modellliste mit diesem Modell$/) do
  visit borrow_models_path(category_id: @model.categories.first)
end

Wenn(/^man wählt alle Geräteparks bis auf einen ab$/) do
  step 'man ein bestimmten Gerätepark in der Geräteparkauswahl auswählt'
end

Wenn(/^man wählt "Alle Geräteparks"$/) do
  within "#ip-selector" do
    find(".dropdown-item", :text => _("All inventory pools")).click
  end
end

Dann(/^sind alle Geräteparks wieder ausgewählt$/) do
  within "#ip-selector" do
    all(".dropdown-item input[type='checkbox']").each do |checkbox|
      expect(checkbox.checked?).to be true
    end
  end
end

Dann(/^die Liste zeigt Modelle aller Geräteparks$/) do
  ip_ids = find("#ip-selector").all(".dropdown-item[data-id]").map{|ip| ip["data-id"]}
  step 'man bis zum Ende der Liste fährt'
  models = @current_user.models.borrowable.from_category_and_all_its_descendants(@category.id).
    all_from_inventory_pools(ip_ids).
    order_by_attribute_and_direction "model", "name"
  within "#model-list" do
    expect(all(".text-align-left").map(&:text).reject{|t| t.empty?}.uniq).to eq models.map(&:name)
  end
end

Angenommen(/^Filter sind ausgewählt$/) do
  find("#model-list-search input").set "a"
  find("input#start-date").set Date.today.strftime("%d.%m.%Y")
  find("input#end-date").set (Date.today + 1).strftime("%d.%m.%Y")
  step "I release the focus from this field"
  expect(has_no_selector?(".ui-datepicker-calendar", :visible => true)).to be true
  find("#ip-selector").click
  within "#ip-selector" do
    expect(has_selector?(".dropdown-item", :visible => true)).to be true
    all(".dropdown-item").last.click
  end
  find("#model-sorting").click
  within "#model-sorting" do
    expect(has_selector?("a", :visible => true)).to be true
    all("a").last.click
  end
end

Angenommen(/^die Schaltfläche "(.*?)" ist aktivert$/) do |arg1|
  expect(find("#reset-all-filter").visible?).to be true
end

Wenn(/^man "Alles zurücksetzen" wählt$/) do
  find("#reset-all-filter").click
  find("#model-list .line", match: :first)
end

Dann(/^sind alle Geräteparks in der Geräteparkauswahl wieder ausgewählt$/) do
  within "#ip-selector" do
    all("input[type='checkbox']").each &:checked?
  end
end

Dann(/^der Ausleihezeitraum ist leer$/) do
  expect(find("input#start-date").value.empty?).to be true
  expect(find("input#end-date").value.empty?).to be true
end

Dann(/^die Sortierung ist nach Modellnamen \(aufsteigend\)$/) do
  find(".button", text: _("Model")).find(".icon-circle-arrow-up", match: :first)
end

Dann(/^die Schaltfläche "(?:.+)" ist deaktiviert$/) do
  expect(has_selector?("#reset-all-filter", visible: false)).to be true
end

Dann(/^das Suchfeld ist leer$/) do
  expect(find("#model-list-search input").value.empty?).to be true
end

Dann(/^man sieht wieder die ungefilterte Liste der Modelle$/) do
  within "#model-list" do
    expect(all(".text-align-left").map(&:text).reject{|t| t.empty?}).to eq @current_user.models.from_category_and_all_its_descendants(@category.id).default_order.paginate(page: 1, per_page: 20).map(&:name)
  end
end

Wenn(/^ich alle Filter manuell zurücksetze$/) do
  find("#model-list-search input").set ""
  find("input#start-date").set ""
  find("input#end-date").set ""
  step "I release the focus from this field"
  expect(all(".ui-datepicker-calendar", :visible => true).empty?).to be true
  find("#ip-selector").click
  expect(has_selector?("#ip-selector .dropdown-item", :visible => true)).to be true
  all("#ip-selector .dropdown-item").first.click
  find("#model-sorting").click
  within "#model-sorting" do
    expect(has_selector?("a", :visible => true)).to be true
    all("a").first.click
  end
end

Dann(/^verschwindet auch die "Alles zurücksetzen" Schaltfläche$/) do
  expect(has_selector?("#reset-all-filter", visible: false)).to be true
end

Dann(/^die Auswahl klappt nocht nicht zu$/) do
  expect(find("#ip-selector .dropdown").visible?).to be true
end

Dann(/^wenn ich den Kalendar für dieses Modell benutze$/) do
  find(".line[data-id='#{@model.id}'] [data-create-order-line]").click
  step "ich wähle ein Startdatum und ein Enddatum an dem der Geräterpark geöffnet ist"
  find("#submit-booking-calendar:not(:disabled)").click
  step "the modal is closed"
end

Dann(/^können die zusätzliche Informationen immer noch abgerufen werden$/) do
  step 'man über das Modell hovered'
  step 'werden zusätzliche Informationen angezeigt zu Modellname, Bilder, Beschreibung, Liste der Eigenschaften'
end

Wenn(/^ich wähle ein Startdatum und ein Enddatum an dem der Geräterpark geöffnet ist$/) do
  step "I see the booking calendar"

  while all(".start-date.selected.available:not(.closed)").empty? do
    find("#booking-calendar-start-date").native.send_key :up
  end

  rand(0..40).times do
    find("#booking-calendar-end-date").native.send_key :up
    find(".end-date")
  end
  begin
    find("#booking-calendar-end-date").native.send_key :up
    find(".end-date")
  end while page.has_selector?(".end-date.closed")

  while all(".end-date.selected.available:not(.closed)").empty? do
    find("#booking-calendar-end-date").native.send_key :up
  end
end
