/*
 * File: app/view/device/selectIpWin.js
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

Ext.define('NeoDoc.view.device.selectIpWin', {
    extend: 'Ext.window.Window',
    alias: 'widget.deviceselectipwin',

    height: 390,
    id: 'deviceselctipwin',
    width: 699,
    layout: {
        type: 'fit'
    },
    title: 'Add IP',
    modal: true,

    initComponent: function() {
        var me = this;

        Ext.applyIf(me, {
            dockedItems: [
                {
                    xtype: 'treepanel',
                    dock: 'left',
                    height: 250,
                    itemId: 'deviceIpTreeGrid',
                    width: 283,
                    title: 'Network Tree',
                    store: 'NetworkIpTreeStore',
                    rootVisible: false,
                    viewConfig: {

                    },
                    columns: [
                        {
                            xtype: 'treecolumn',
                            dataIndex: 'text',
                            text: 'Network',
                            flex: 1
                        },
                        {
                            xtype: 'gridcolumn',
                            dataIndex: 'vlanid',
                            text: 'VLAN'
                        }
                    ],
                    listeners: {
                        selectionchange: {
                            fn: me.onNetworkIpTreeGridSelectionChange,
                            scope: me
                        }
                    }
                }
            ],
            items: [
                {
                    xtype: 'form',
                    itemId: 'deviceIpTreeGridForm',
                    width: 266,
                    autoScroll: true,
                    bodyPadding: 10,
                    title: 'Add IP',
                    items: [
                        {
                            xtype: 'fieldset',
                            height: 120,
                            margin: '0 0 0 10',
                            title: 'IP Details',
                            items: [
                                {
                                    xtype: 'textfield',
                                    fieldLabel: 'IP',
                                    name: 'text',
                                    readOnly: true,
                                    allowBlank: false,
                                    emptyText: 'xxx.yyy.zzz.qqq'
                                },
                                {
                                    xtype: 'combobox',
                                    fieldLabel: 'NIC',
                                    name: 'nic'
                                },
                                {
                                    xtype: 'combobox',
                                    fieldLabel: 'Type',
                                    name: 'type'
                                },
                                {
                                    xtype: 'hiddenfield',
                                    fieldLabel: 'Label',
                                    name: 'ipid'
                                },
                                {
                                    xtype: 'hiddenfield',
                                    fieldLabel: 'Label',
                                    name: 'pidId'
                                }
                            ]
                        }
                    ],
                    dockedItems: [
                        {
                            xtype: 'toolbar',
                            dock: 'bottom',
                            itemId: 'deviceIpTreeGridFormToolBar',
                            items: [
                                {
                                    xtype: 'button',
                                    iconCls: 'reset-btn',
                                    text: 'Reset'
                                },
                                {
                                    xtype: 'tbspacer',
                                    flex: 1
                                },
                                {
                                    xtype: 'button',
                                    formBind: true,
                                    iconCls: 'cancel-btn',
                                    text: 'Cancel',
                                    listeners: {
                                        click: {
                                            fn: me.onCancelButtonClick,
                                            scope: me
                                        }
                                    }
                                },
                                {
                                    xtype: 'button',
                                    formBind: true,
                                    action: 'addipaddressbtn',
                                    iconCls: 'submit-btn',
                                    text: 'Submit'
                                }
                            ]
                        }
                    ]
                }
            ]
        });

        me.callParent(arguments);
    },

    onNetworkIpTreeGridSelectionChange: function(model, selected, eOpts) {
        console.log("in Selection changed");

        var rec = selected[0];

        console.log(rec);
        console.log(this);

        var form = this.down('#deviceIpTreeGridForm').getForm();

        console.log(form);

        if (rec) {
            form.loadRecord(rec);
            form.findField('ipid').setValue(rec.data.id);
            //    console.log(form.findField('ipid').getValue());
        }

    },

    onCancelButtonClick: function(button, e, eOpts) {
        console.log('In cancel button');
        Ext.MessageBox.confirm('Confirm', 'Are you sure you want to close the window?', showResult);


    }

});