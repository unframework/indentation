
define ['indentation', 'text!indentation.js' ], (indentation, indentationSrc) ->

  describe 'indentation', ->
    it 'does not define a global in the AMD environment', ->
      expect(window.indentation).toBe undefined

    it 'defines a global in a non-AMD environment', ->
      # @todo this better?
      fakeScope = { define: null, window: {} }
      `with (fakeScope) { eval(indentationSrc) }`
      expect(fakeScope.window.indentation).not.toBe undefined

      # extra check to make sure there was no global exposure
      expect(window.indentation).toBe undefined

    it 'defines only the fork method on initial template instance object', ->
      # this would not be done normally, but "clean object" is part of the spec
      memberList = null
      indentation -> memberList = (n for own n, v of this)

      memberList.sort()
      expect(memberList.join(',')).toBe 'fork'

    it 'forks view state', ->
      view1 = null
      view2 = null
      indentation ->
        view1 = this
        @TEST_PROP = 'TEST_VALUE'

        @fork ->
          view2 = this
          @TEST_PROP = 'VAL2'
          @TEST_PROP2 = 'VAL3'

      expect(view1.TEST_PROP).toBe 'TEST_VALUE'
      expect(view2.TEST_PROP).toBe 'VAL2'
      expect(view2.TEST_PROP2).toBe 'VAL3'
