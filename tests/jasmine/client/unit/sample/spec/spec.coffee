describe 'Groups', ->
  describe 'paths', ->
    it 'should be lowercase and alphanumeric', ->
      Groups.insert
        name: "Test Name!"
        description: "test group"
      expect(Groups.findOne()?.path).toBe "test-name-"
