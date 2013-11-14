# encoding: utf-8
def add_item_via_autocomplete input_value, element
  element.set input_value
  find("a", match: :prefer_exact, text: input_value).click
end

Wenn /^ich mindestens die Pflichtfelder ausfülle$/ do
  @model_name = "Test Modell-Paket"
  find(".row.emboss", match: :prefer_exact, :text => _("Name")).fill_in 'name', :with => @model_name
end

Wenn /^ich eines oder mehrere Pakete hinzufüge$/ do
  find("a", match: :prefer_exact, text: _("Add %s") % _("Package")).click
end

Wenn /^ich(?: kann | )diesem Paket eines oder mehrere Gegenstände hinzufügen$/ do
  add_item_via_autocomplete "beam123", first(".modal #add-item .autocomplete")
  add_item_via_autocomplete "beam345", first(".modal #add-item .autocomplete")
end

Dann /^ist das Modell erstellt und die Pakete und dessen zugeteilten Gegenstände gespeichert$/ do
  page.should have_selector ".success"
  @model = Model.find_by_name @model_name
  @model.should_not be_nil
  @model.should be_is_package
  @packages = @model.items
  @packages.count.should eq 1
  @packages.first.children.first.inventory_code.should eql "beam123"
  @packages.first.children.second.inventory_code.should eql "beam345"
end

Dann /^den Paketen wird ein Inventarcode zugewiesen$/ do
  @packages.first.inventory_code.should_not be_nil
end

Wenn /^das Paket zurzeit nicht ausgeliehen ist$/ do
  @package = @current_inventory_pool.items.packages.in_stock.first
  visit "/manage/%d/models/%d/edit" % [@current_inventory_pool.id, @package.model.id]
end

Dann /^kann ich das Paket löschen und die Gegenstände sind nicht mehr dem Paket zugeteilt$/ do
  @package_item_ids = @package.children.map(&:id)
  find(".field-inline-entry", :text => @package.inventory_code).first(".clickable", :text => _("Delete")).click
  step 'ich speichere die Informationen'
  find(".top", match: :prefer_exact, text: _("List of Models"))
  Item.find_by_id(@package.id).nil?.should be_true
  lambda {@package.reload}.should raise_error(ActiveRecord::RecordNotFound)
  @package_item_ids.size.should > 0
  @package_item_ids.each{|id| Item.find(id).parent_id.should be_nil}
end

Wenn /^das Paket zurzeit ausgeliehen ist$/ do
  @package_not_in_stock = @current_inventory_pool.items.packages.not_in_stock.first
  visit "/manage/%d/models/%d/edit" % [@current_inventory_pool.id, @package_not_in_stock.model.id]
end

Dann /^kann ich das Paket nicht löschen$/ do
  find(".field-inline-entry", :text => @package_not_in_stock.inventory_code).all(".clickable", :text => _("Delete")).size.should == 0
end

Wenn /^ich ein Modell editiere, welches bereits Pakete hat$/ do
  visit "/manage/#{@current_inventory_pool.id}/inventory"
  @model = @current_inventory_pool.models.detect {|m| not m.items.empty? and m.is_package?}
  @model_name = @model.name
  step 'ich nach "%s" suche' % @model.name
  page.should have_selector(".line", text: @model.name)
  find(".line", match: :prefer_exact, :text => @model.name).first(".button", :text => _("Edit Model")).click
end

Wenn /^ich ein Modell editiere, welches bereits Gegenstände hat$/ do
  visit "/manage/#{@current_inventory_pool.id}/inventory"
  @model = @current_inventory_pool.models.detect {|m| not (m.items.empty? and m.is_package?)}
  @model_name = @model.name
  step 'ich nach "%s" suche' % @model.name
  page.should have_selector(".line", text: @model.name)
  find(".line", match: :prefer_exact, :text => @model.name).first(".button", :text => _("Edit Model")).click
end

Dann /^kann ich diesem Modell keine Pakete mehr zuweisen$/ do
  page.should_not have_selector("a", text: _("Add %s") % _("Package"))
end

Wenn /^ich einem Modell ein Paket hinzufüge$/ do
  step "ich ein neues Modell hinzufüge"
  step 'ich mindestens die Pflichtfelder ausfülle'
  step "ich eines oder mehrere Pakete hinzufüge"
end

Dann /^kann ich dieses Paket nur speichern, wenn dem Paket auch Gegenstände zugeteilt sind$/ do
  click_button _("Save")
  page.should have_content _("You can not create a package without any item")
  page.should have_content _("New Package")
  click_button _("Cancel")
  find(".row.emboss", match: :prefer_exact, text: _("Packages")).should_not have_selector ".field-inline-entry"
end

Wenn /^ich ein Paket editiere$/ do
  @model = Model.find_by_name "Kamera Set"
  visit "/manage/%d/models/%d/edit" % [@current_inventory_pool.id, @model.id]
  @package_to_edit = @model.items.detect &:in_stock?
  find(".field-inline-entry", text: @package_to_edit.inventory_code).find(".clickable", text: _("Edit")).click
end

Dann /^kann ich einen Gegenstand aus dem Paket entfernen$/ do
  items = all(".modal .inventory_code")
  @number_of_items_before = items.size
  @item_to_remove = items.first.text
  find(".removeItem", match: :first).click
  click_button _("Save")
  step 'ich speichere die Informationen'
end

Dann /^dieser Gegenstand ist nicht mehr dem Paket zugeteilt$/ do
  page.has_content? _("List of Models")
  @package_to_edit.reload
  @package_to_edit.children.count.should eq (@number_of_items_before - 1)
  @package_to_edit.children.detect {|i| i.inventory_code == @item_to_remove}.should be_nil
end

Dann /^werden die folgenden Felder angezeigt$/ do |table|
  values = table.raw.map do |x|
    x.first.gsub(/^\-\ |\ \-$/, '')
  end
  (page.text =~ Regexp.new(values.join('.*'), Regexp::MULTILINE)).should_not be_nil
end

Wenn /^ich das Paket speichere$/ do
  find(".modal .save", match: :first).click
end

Wenn /^ich das Paket und das Modell speichere$/ do
  step 'ich das Paket speichere'
  find(".content_navigation .button.green", match: :first).click
end

Dann /^(?:besitzt das Paket alle angegebenen Informationen|das Paket besitzt alle angegebenen Informationen)$/ do
  sleep(0.88)
  model = Model.find_by_name @model_name
  visit "/manage/%d/models/%d/edit" % [@current_inventory_pool.id, model.id]
  page.should have_selector "[ng-repeat='package in model.packages']"
  find("[ng-repeat='package in model.packages']", match: :first).first(".clickable", :text => _("Edit")).click
  step 'hat der Gegenstand alle zuvor eingetragenen Werte'
end

Wenn /^ich ein bestehendes Paket editiere$/ do
  page.should have_selector "[ng-repeat='package in model.packages']"
  find("[ng-repeat='package in model.packages']", match: :first).first(".clickable", :text => _("Edit")).click
end

Wenn(/^ich eine Paket hinzufüge$/) do
  find("a", match: :prefer_exact, text: _("Add %s") % _("Package")).click
end

Wenn(/^ich die Paketeigenschaften eintrage$/) do
  steps %Q{Und ich die folgenden Informationen erfasse
    | Feldname                     | Type         | Wert                          |
    | Zustand                      | radio        | OK                            |
    | Vollständigkeit              | radio        | OK                            |
    | Ausleihbar                   | radio        | OK                            |
    | Inventarrelevant             | select       | Ja                            |
    | Letzte Inventur              |              | 01.01.2013                    |
    | Verantwortliche Abteilung    | autocomplete | A-Ausleihe                    |
    | Verantwortliche Person       |              | Matus Kmit                    |
    | Benutzer/Verwendung          |              | Test Verwendung               |
    | Name                         |              | Test Name                     |
    | Notiz                        |              | Test Notiz                    |
    | Gebäude                      | autocomplete | Keine/r                       |
    | Raum                         |              | Test Raum                     |
    | Gestell                      |              | Test Gestell                  |
    | Anschaffungswert             |              | 50.0                          |}
end

Wenn(/^ich dieses Paket speichere$/) do
  find(".modal .button.save", match: :first).click
end

Wenn(/^ich dieses Paket wieder editiere$/) do
  find(".field-inline-entry .clickable", match: :prefer_exact, text: _("Edit")).click
end

Dann(/^kann ich die Paketeigenschaften erneut bearbeiten$/) do
  step 'ich die Paketeigenschaften eintrage'
end

Dann(/^sehe ich die Meldung "(.*?)"$/) do |text|
  find(".notification.headline", match: :prefer_exact, :text => text)
end