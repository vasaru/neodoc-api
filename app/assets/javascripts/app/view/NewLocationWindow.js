/*
 * File: app/view/NewLocationWindow.js
 *
 * This file was generated by Sencha Architect version 2.2.0.
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

Ext.define('NeoDoc.view.NewLocationWindow', {
    extend: 'Ext.window.Window',
    alias: 'widget.newlocationwindow',

    height: 461,
    width: 666,
    layout: {
        type: 'fit'
    },
    title: 'New Location',
    modal: true,

    initComponent: function() {
        var me = this;

        Ext.applyIf(me, {
            items: [
                {
                    xtype: 'form',
                    layout: {
                        align: 'stretch',
                        type: 'hbox'
                    },
                    bodyPadding: 10,
                    header: false,
                    dockedItems: [
                        {
                            xtype: 'container',
                            flex: 1,
                            dock: 'top',
                            height: 121,
                            padding: 10,
                            layout: {
                                type: 'anchor'
                            },
                            items: [
                                {
                                    xtype: 'textfield',
                                    anchor: '100%',
                                    fieldLabel: 'Name',
                                    name: 'name',
                                    tabIndex: 1,
                                    allowBlank: false,
                                    allowOnlyWhitespace: false
                                },
                                {
                                    xtype: 'textareafield',
                                    anchor: '100%',
                                    fieldLabel: 'Address',
                                    name: 'address'
                                }
                            ]
                        },
                        {
                            xtype: 'toolbar',
                            flex: 1,
                            dock: 'bottom',
                            formBind: true,
                            items: [
                                {
                                    xtype: 'button',
                                    text: 'Reset'
                                },
                                {
                                    xtype: 'tbspacer',
                                    flex: 1
                                },
                                {
                                    xtype: 'button',
                                    text: 'Cancel'
                                },
                                {
                                    xtype: 'button',
                                    action: 'locationcreate',
                                    text: 'Create'
                                }
                            ]
                        }
                    ],
                    items: [
                        {
                            xtype: 'container',
                            padding: 10,
                            width: 297,
                            layout: {
                                type: 'anchor'
                            },
                            items: [
                                {
                                    xtype: 'combobox',
                                    anchor: '100%',
                                    fieldLabel: 'Country',
                                    name: 'country',
                                    displayField: 'name',
                                    queryMode: 'local',
                                    store: 'countryStore'
                                },
                                {
                                    xtype: 'textfield',
                                    anchor: '100%',
                                    fieldLabel: 'Longitude',
                                    name: 'longitude'
                                },
                                {
                                    xtype: 'textfield',
                                    anchor: '100%',
                                    fieldLabel: 'Latitude',
                                    name: 'latitude'
                                },
                                {
                                    xtype: 'textfield',
                                    anchor: '100%',
                                    fieldLabel: 'Url',
                                    name: 'url',
                                    inputType: 'url'
                                }
                            ]
                        },
                        {
                            xtype: 'container',
                            flex: 1,
                            layout: {
                                type: 'anchor'
                            },
                            items: [
                                {
                                    xtype: 'textareafield',
                                    height: 216,
                                    padding: 10,
                                    width: 327,
                                    fieldLabel: 'Description',
                                    name: 'description'
                                }
                            ]
                        }
                    ]
                }
            ]
        });

        me.callParent(arguments);
    }

});