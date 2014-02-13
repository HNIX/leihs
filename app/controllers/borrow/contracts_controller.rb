class Borrow::ContractsController < Borrow::ApplicationController

  before_filter :only => [:current, :timed_out] do
    @grouped_and_merged_lines = Contract.grouped_and_merged_lines(unsubmitted_contracts.flat_map(&:lines))
    @models = unsubmitted_contracts.flat_map(&:lines).map(&:model).uniq
    @inventory_pools = unsubmitted_contracts.flat_map(&:lines).map(&:inventory_pool).uniq
  end

  def index
    respond_to do |format|
      format.json { @contracts = Contract.filter params, current_user }
      format.html { @grouped_and_merged_lines = Contract.grouped_and_merged_lines current_user.contracts.submitted.flat_map(&:lines) }
    end
  end

  def current
    @lines = unsubmitted_contracts.flat_map(&:lines)
  end

  def submit
    Contract.transaction do
      unsubmitted_contracts.each do |c|
        c.created_at = DateTime.now
        c.delegated_user = c.user.delegated_users.find(session[:delegated_user_id]) if c.user.is_delegation
      end
      if unsubmitted_contracts.all? {|c| c.submit(params[:purpose])}
        flash[:notice] = _("Your order has been successfully submitted, but is NOT YET APPROVED.")
        redirect_to borrow_root_path
      else
        flash[:error] = unsubmitted_contracts.flat_map{|c| c.errors.full_messages }.uniq.join("\n")
        redirect_to borrow_current_order_path
        raise ActiveRecord::Rollback
      end
    end
  end

  def remove
    unsubmitted_contracts.each(&:destroy)
    redirect_to borrow_root_path
  end

  def remove_lines(line_ids = params[:line_ids].map(&:to_i))
    lines = unsubmitted_contracts.flat_map(&:lines).select {|line| line_ids.include? line.id }
    lines.each {|l| unsubmitted_contracts.each {|c| c.remove_line(l, current_user.id)} }
    redirect_to borrow_current_order_path
  end

  def timed_out
    flash[:error] = _("%d minutes passed. The items are not reserved for you any more!") % Contract::TIMEOUT_MINUTES
    @timed_out = true
    @lines = unsubmitted_contracts.flat_map(&:lines)
    render :current
  end

  def delete_unavailables
    unsubmitted_contracts.flat_map(&:lines).each {|l| l.delete unless l.available? }
    redirect_to borrow_current_order_path, flash: {success: _("Your order has been modified. All reservations are now available.")}
  end

end
