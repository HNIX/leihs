class Mailer::Order < ActionMailer::Base

  def choose_language_for(contract)
    #set_locale(contract.target_user.language.locale_name)#NOTE: not working anymore "set_locale"
    I18n.locale = contract.target_user.language.locale_name || I18n.default_locale
  end

  def approved(order, comment, sent_at = Time.now)
    choose_language_for(order)
    @order = order
    @comment = comment
    mail( :to => order.target_user.email,
          :from => (order.inventory_pool.email || Setting::DEFAULT_EMAIL),
          :subject => _('[leihs] Reservation Confirmation'),
          :date => sent_at )
  end

  def submitted(order, purpose, sent_at = Time.now)
    choose_language_for(order)
    @order = order
    @purpose = purpose
    mail( :to => order.target_user.email,
          :from => (order.inventory_pool.email || Setting::DEFAULT_EMAIL),
          :subject => _('[leihs] Reservation Submitted'),
          :date => sent_at )
  end

  def received(order, purpose, sent_at = Time.now)
    choose_language_for(order)
    @order = order
    @purpose = purpose
    mail( :to => (order.inventory_pool.email || Setting::DEFAULT_EMAIL),
          :from => (order.inventory_pool.email || Setting::DEFAULT_EMAIL),
          :subject => _('[leihs] Order received'),
          :date => sent_at )
  end

  def rejected(order, comment, sent_at = Time.now)
    choose_language_for(order)
    @order = order
    @comment = comment
    mail( :to => order.target_user.email,
          :from => (order.inventory_pool.email || Setting::DEFAULT_EMAIL),
          :subject => _('[leihs] Reservation Rejected'),
          :date => sent_at )
  end

  def changed(order, comment, sent_at = Time.now)
    choose_language_for(order)
    @order = order
    @comment = comment
    mail( :to => order.target_user.email,
          :from => (order.inventory_pool.email || Setting::DEFAULT_EMAIL),
          :subject => _('[leihs] Reservation confirmed (with changes)'),
          :date => sent_at )
  end
end
