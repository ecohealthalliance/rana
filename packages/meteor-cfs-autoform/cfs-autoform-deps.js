/**
 * A wrapper around Tracker.Dependency to track categories of changes for
 * particular objects.  This can be useful if you want to track a change on
 * a list of objects, but only want to reactively update the one that changed.
 * So, if one calls add('status', id); (where id is the _id of a Mongo
 * collection document.  You can depend('status', id) on the object in another
 * part of your code.  Then whenever changed('status', id) is called, the
 * dependency is reevaluated.
 * @external Tracker.Dependency
 */


deps = {
  _depObjs: {},

  _thisObj: function(name, id) {
    if (! deps._depObjs[name]) deps._depObjs[name] = {};
    return deps._depObjs[name][id + ''];
  },


  /**
   * create - creates a dependency object with a particular name for an id,
   * if a dependency does not already exist.  It simply returns the dependency
   * if it does exist.
   * This is useful to track a dependency on a particular object
   * @param {String} name - the name of the dependency
   * @param {*} id - the id of the object tracked
   * @return {Tracker.Dependency} - the dependency object
   */
  create: function(name, id) {
    if (_.isUndefined(id)) id = '0';
    if (_.isUndefined(name) || name === '' || id === '') return false;
    if (! deps.get(name, id)) {
      deps._depObjs[name][id + ''] = new Tracker.Dependency;
    }
    return deps._depObjs[name][id + ''];
  },


  /**
   * add - creates and adds a dependency for a particular name and id
   * @param {String} name - the name of the dependency object
   * @param {*} id - the object it
   * @return {Tracker.Dependency} the new dependency object
   */
  add: function(name, id) {
    if (_.isUndefined(id)) id = '0';
    if (_.isUndefined(name) || name === '' || id === '') return false;
    return deps.create(name, id).depend();
  },


  /**
   * remove - removed a dependency
   * @param {String} name - the name of the dependency
   * @param {*} id - the id of the object (coerced to String)
   */
  remove: function(name, id) {
    if (_.isUndefined(id)) id = '0';
    delete deps._depObjs[name][id + ''];
  },


  /**
   * Gets a dependency object
   * @param {String} name - the name of the dependency
   * @param {*} id - the id of the object
   * @return {Tracker.Dependency} the dependency object
   */
  get: function(name, id) {
    if (_.isUndefined(id)) id = '0';
    return deps._thisObj(name, id);
  },


  /**
   * Creates a dependency on a dependency object
   * @param {String} name - the name of the dependency object
   * @param {*} id - the id of the object
   * @return {*}
   */
  depend: function(name, id) {
    if (_.isUndefined(id)) id = '0';
    if (! deps.exists(name, id)) return false;
    return deps.get(name, id).depend();
  },


  /**
   * Signals a change has occured and dependencies should be notified
   * @param {String} name - the name of the dependency
   * @param {*} id - the id of the object
   * @return {*}
   */
  changed: function(name, id) {
    if (_.isUndefined(id)) id = '0';
    if (! deps.exists(name, id)) return false;
    return deps.get(name, id).changed();
  },


  /**
   * Determines if a dependency object has been created for a particular name
   * and id
   * @param {String} name - the name of the dependency
   * @param {*} id - the id of the object
   * @return {boolean}
   */
  exists: function(name, id) {
    if (_.isUndefined(id)) id = '0';
    if (!deps._depObjs[name]) return false;
    return deps._depObjs[name][id + ''] != undefined;
  }
}