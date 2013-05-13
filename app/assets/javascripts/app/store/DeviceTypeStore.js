/*
 * File: app/store/DeviceTypeStore.js
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

Ext.define('NeoDoc.store.DeviceTypeStore', {
    extend: 'Ext.data.Store',

    constructor: function(cfg) {
        var me = this;
        cfg = cfg || {};
        me.callParent([Ext.apply({
            storeId: 'DeviceTypeStore',
            data: [
                [
                    'VM',
                    'VM'
                ],
                [
                    'Physical',
                    'Physical'
                ],
                [
                    'Switch',
                    'Switch'
                ]
            ],
            fields: [
                {
                    name: 'text'
                },
                {
                    name: 'name'
                }
            ]
        }, cfg)]);
    }
});