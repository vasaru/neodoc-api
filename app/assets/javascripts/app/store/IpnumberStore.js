/*
 * File: app/store/IpnumberStore.js
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

Ext.define('NeoDoc.store.IpnumberStore', {
    extend: 'Ext.data.Store',

    requires: [
        'NeoDoc.model.network.IpModel'
    ],

    constructor: function(cfg) {
        var me = this;
        cfg = cfg || {};
        me.callParent([Ext.apply({
            model: 'NeoDoc.model.network.IpModel',
            storeId: 'networkIpStore',
            groupField: 'status',
            pageSize: 255,
            proxy: {
                type: 'ajax',
                url: '/api/networks',
                headers: {
                    Accept: 'application/vnd.neodocapi.v1'
                },
                reader: {
                    type: 'json',
                    idProperty: 'id',
                    root: 'ipnumbers',
                    totalProperty: 'totalCount'
                }
            }
        }, cfg)]);
    }
});