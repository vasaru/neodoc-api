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
    width: 400,
    title: 'My Grid Panel',
    emptyText: 'No devices availble for this location',

    initComponent: function() {
        var me = this;

        Ext.applyIf(me, {
            features: [
                {
                    ftype: 'grouping',
                    groupByText: 'devicetype'
                },
                {
                    ftype: 'rowbody',
                    getAdditionalData: function(data, idx, record, orig) {
                        console.log('In getAdditionalData');
                        console.log(record);

                    }
                }
            ],
            columns: [
                {
                    xtype: 'gridcolumn',
                    dataIndex: 'name',
                    text: 'Device'
                },
                {
                    xtype: 'gridcolumn',
                    dataIndex: 'devicetype',
                    text: 'Device Type'
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
            },
            dockedItems: [
                {
                    xtype: 'pagingtoolbar',
                    dock: 'bottom',
                    width: 360,
                    displayInfo: true,
                    items: [
                        {
                            xtype: 'checkboxfield',
                            boxLabel: 'Toggle Grouping',
                            checked: true,
                            listeners: {
                                change: {
                                    fn: me.onCheckboxfieldChange,
                                    scope: me
                                }
                            }
                        }
                    ]
                }
            ]
        });

        me.callParent(arguments);
    },

    onCheckboxfieldChange: function(field, newValue, oldValue, eOpts) {
        console.log('in grouping feature toggle');
        var view = this.getView(),
            ft = view.getFeature(0);

        console.log(ft);

        if(ft.disabled) 
        ft.enable();
        else
        ft.disable();



    }

});