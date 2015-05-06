/**
 * Event handlers
 * @type {Object}
 */

events = {

  /**
   * handles clicking on a field
   * @param {*} e - event
   * @param {*} t - template
   */
  'click .cfsaf-field': function(e, t) {
    t.$(CfsAutoForm.defs.hidden_css).click();
  },


  /**
   * Handles cliking on the remove button/link
   * @param {*} e - event
   * @param {*} t - template
   * @this events
   */
  'click .file-upload-clear': function(e, t) {
    //mark the file as removed
    var fObj = t.$(CfsAutoForm.defs.hidden_css);
    var imgObj = t.$('.cfsaf-thumb');
    var ids = fObj.attr(CfsAutoForm.defs.id_attr).split(',') || [];

    //remove the id
    fObj.attr(CfsAutoForm.defs.id_attr, _(ids).without(this._id));
    t.data.atts[CfsAutoForm.defs.id_attr] = _(ids).without(this._id);
    //set the data to cleared
    //fObj.val('');
    //this.atts['value'] = '';
    //don't remove the cfsaf-data-id because we need to
    //use it if we delete on remove (later)

    //move the file into the delete list
    var deletes = fObj.data(CfsAutoForm.defs.delete_files_data) || [];
    deletes.push(this);
    fObj.data(CfsAutoForm.defs.delete_files_data, deletes);

    //trigger reactive update for this id
    fObj.attr(CfsAutoForm.defs.status_attr, CfsAutoForm.defs.status.updated);
    t.data.atts[CfsAutoForm.defs.status_attr] = CfsAutoForm.defs.status.updated;
    CfsAutoForm.deps.changed('status', this._id);
  }
};
