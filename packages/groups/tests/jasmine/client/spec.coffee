describe 'Groups', ->
  describe 'the group path', ->
    it 'should be set to ...', ->
      Groups.insert
        name: "test"
        path: "test"
        description: "test group"
      expect(Groups.findOne()?.path).toBe "test"
