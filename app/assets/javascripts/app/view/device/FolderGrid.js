/*
 * File: app/view/device/FolderGrid.js
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

Ext.define('NeoDoc.view.device.FolderGrid', {
    extend: 'Ext.grid.Panel',
    alias: 'widget.devicefoldergrid',

    height: 250,
    id: 'DevFolderTab-Grid',
    itemId: 'devfoldertabgrid',
    width: 867,
    collapsible: false,
    title: 'My Grid Panel',
    emptyText: 'No devices availble for this location',

    initComponent: function() {
        var me = this;

        Ext.applyIf(me, {
            columns: [
                {
                    xtype: 'gridcolumn',
                    width: 108,
                    dataIndex: 'name',
                    groupable: false,
                    text: 'Device'
                },
                {
                    xtype: 'gridcolumn',
                    dataIndex: 'devicetype',
                    text: 'Device Type'
                },
                {
                    xtype: 'gridcolumn',
                    dataIndex: 'model',
                    text: 'Model'
                },
                {
                    xtype: 'gridcolumn',
                    dataIndex: 'serialnr',
                    text: 'Serial Number'
                },
                {
                    xtype: 'gridcolumn',
                    dataIndex: 'label',
                    text: 'Label'
                },
                {
                    xtype: 'datecolumn',
                    dataIndex: 'created_at',
                    text: 'Created At'
                },
                {
                    xtype: 'datecolumn',
                    dataIndex: 'updated_at',
                    text: 'Updated At'
                },
                {
                    xtype: 'gridcolumn',
                    dataIndex: 'updated_by',
                    text: 'Updated By'
                },
                {
                    xtype: 'gridcolumn',
                    dataIndex: 'created_by',
                    text: 'Created By'
                },
                {
                    xtype: 'actioncolumn',
                    items: [
                        {
                            disabled: true
                        }
                    ]
                }
            ],
            viewConfig: {
                id: 'FolderGridView',
                itemId: 'FolderGridView'
            }
        });

        me.callParent(arguments);
    }

});