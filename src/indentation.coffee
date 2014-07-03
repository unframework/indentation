
(if define? then define else ((module) -> window.indentation = module()))(->
  (rootTemplate) ->
    rootView =
      fork: (subTemplate) ->
        # create clean sub-view model and initialize it with given values
        # @todo use Object.create
        subView = {}
        subView.__proto__ = this

        subTemplate.call subView
        undefined # prevent stray output

    rootTemplate.call rootView
)
