class window.App.ContractsEditController extends Spine.Controller

  elements:
    "#status": "status"
    "#lines": "linesContainer"
    "#purpose": "purposeContainer"
    "#reject-contract": "rejectButton"
    "#approve-contract": "approveButton"

  events:
    "click #edit-purpose.button": "editPurpose"
    "click #swap-user": "swapUser"
    "click #approve-with-comment": "approveContractWithComment"
    "click [data-destroy-line]": "validateLineDeletion"
    "click [data-destroy-lines]": "validateLineDeletion"
    "click [data-destroy-selected-lines]": "validateLineDeletion"

  constructor: ->
    super 
    do @setupLineSelection
    do @fetchAvailability
    do @setupAddLine
    new App.TimeLineController {el: @el}
    new App.ContractsApproveController {el: @el, done: @contractApproved}
    new App.ContractsRejectController {el: @el, async: false}
    new App.ContractLinesDestroyController {el: @el}
    new App.ContractLinesEditController {el: @el, user: @contract.user(), contract: @contract}

  delegateEvents: =>
    super
    App.Purpose.on "update", @renderPurpose
    App.ContractLine.on "change destroy", @fetchAvailability
    App.Contract.on "refresh", @fetchAvailability
  
  setupAddLine: =>
    new App.ContractLinesAddController
      el: @el.find("#add")
      user: @contract.user()
      status: @status
      contract: @contract
      purpose: @purpose

  setupLineSelection: =>
    @lineSelection = new App.LineSelectionController
      el: @el

  validateLineDeletion: (e)=>
    ids = if $(e.currentTarget).closest("[data-id]").length
        [$(e.currentTarget).closest("[data-id]").data("id")]
      else if $(e.currentTarget).data("ids")?
        $(e.currentTarget).data("ids")
      else
        App.LineSelectionController.selected
    if @contract.lines().all().length <= ids.length
      App.Flash
        type: "error"
        message: _jed "You cannot delete all lines of an contract. Perhaps you want to reject it instead?"
      e.stopImmediatePropagation()
      return false

  fetchAvailability: =>
    @render false
    @status.html App.Render "manage/views/availabilities/loading"
    App.Availability.ajaxFetch
      data: $.param
        model_ids: _.uniq(_.map(@contract.lines().all(), (l)->l.model().id))
        user_id: @contract.user_id
    .done (data)=>
      @status.html App.Render "manage/views/availabilities/loaded"
      @render true

  render: (renderAvailability)=> 
    @linesContainer.html App.Render "manage/views/lines/grouped_lines", @contract.groupedLinesByDateRange(true), 
      linePartial: "manage/views/lines/order_line"
      renderAvailability: renderAvailability
    do @lineSelection.restore

  editPurpose: =>
    new App.ContractsEditPurposeController
      purpose: @purpose

  swapUser: =>
    new App.SwapUsersController
      contract: @contract
      manageContactPerson: true

  renderPurpose: => @purposeContainer.html @purpose.description

  approveContractWithComment: =>
    new App.ContractsApproveWithCommentController
      trigger: @approveButton
      contract: @contract

  contractApproved: =>
    window.location = "/manage/#{App.InventoryPool.current.id}/daily?flash[success]=#{_jed('Order approved')}"
