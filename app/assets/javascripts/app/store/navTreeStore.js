/*
 * File: app/store/navTreeStore.js
 *
 * This file was generated by Sencha Architect version 2.2.2.
 * http://www.sencha.com/products/architect/
 *
 * This file requires use of the Ext JS 4.2.x library, under independent license.
 * License of Sencha Architect does not include license for Ext JS 4.2.x. For more
 * details see http://www.sencha.com/license or contact license@sencha.com.
 *
 * This file will be auto-generated each and everytime you save your project.
 *
 * Do NOT hand edit this file.
 */

Ext.define('NeoDoc.store.navTreeStore', {
    extend: 'Ext.data.TreeStore',

    requires: [
        'NeoDoc.model.locationTreeModel'
    ],

    constructor: function(cfg) {
        var me = this;
        cfg = cfg || {};
        me.callParent([Ext.apply({
            autoLoad: false,
            model: 'NeoDoc.model.locationTreeModel',
            storeId: 'navTreeStore',
            defaultRootId: 'src',
            proxy: {
                type: 'ajax',
                url: '/api/trees',
                headers: {
                    Accept: 'application/vnd.neodocapi.v1'
                },
                reader: {
                    type: 'json'
                }
            }
        }, cfg)]);
    }
});