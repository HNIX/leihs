###

  Datepicker

  This script provides functionalities for datepicker things 
  for Item editing (flexible fields)
  
###

jQuery ->
  $(document).on "focus", "input[data-type='datepicker']", (event)->
    $this = $(this)
    unless $this.hasClass("hasDatepicker")
      $this.datepicker()
      value_el = $this.prev("input[type=hidden]")
      $this.val moment(value_el.val()).format(i18n.date.L) if value_el.val().length
      $this.on "change", -> 
        value = $this.val()
        value = moment(value, i18n.date.L).format("YYYY-MM-DD") unless _.isEmpty value
        value_el.val value
