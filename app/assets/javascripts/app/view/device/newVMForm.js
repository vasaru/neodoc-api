/*
 * File: app/view/device/newVMForm.js
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

Ext.define('NeoDoc.view.device.newVMForm', {
    extend: 'Ext.form.Panel',
    alias: 'widget.devicenewvmform',

    height: 504,
    id: 'deviceNewVMForm',
    itemId: 'deviceNewVMForm',
    padding: '',
    width: 719,
    bodyPadding: 10,

    initComponent: function() {
        var me = this;

        Ext.applyIf(me, {
            items: [
                {
                    xtype: 'fieldset',
                    height: 50,
                    layout: {
                        type: 'hbox'
                    },
                    title: 'Operating System',
                    items: [
                        {
                            xtype: 'combobox',
                            formBind: false,
                            id: 'device.vm.os',
                            width: 336,
                            fieldLabel: 'OS:',
                            name: 'operatingsystem',
                            size: 40,
                            editable: false,
                            displayField: 'name',
                            store: 'OperatingSystemStore',
                            valueField: 'id',
                            listeners: {
                                select: {
                                    fn: me.onosSelect,
                                    scope: me
                                }
                            }
                        },
                        {
                            xtype: 'combobox',
                            disabled: true,
                            id: 'device.vm.osversion',
                            itemId: 'devicevmosversion',
                            padding: '0 0 0 10',
                            fieldLabel: 'Version',
                            labelWidth: 50,
                            name: 'version',
                            editable: false,
                            displayField: 'name',
                            store: 'VersionStore',
                            valueField: 'id'
                        }
                    ]
                },
                {
                    xtype: 'fieldset',
                    height: 164,
                    id: 'device.vm.parts',
                    padding: 5,
                    autoScroll: true,
                    resizable: true,
                    layout: {
                        columns: 2,
                        type: 'table'
                    },
                    title: 'Devices',
                    items: [
                        {
                            xtype: 'numberfield',
                            id: 'device.vm.memory',
                            fieldLabel: 'Memory',
                            name: 'memory',
                            value: 1
                        },
                        {
                            xtype: 'combobox',
                            id: 'device.vm.memmetric',
                            padding: '0 0 0 5',
                            name: 'memmetric',
                            value: [
                                'GB',
                                'GB'
                            ],
                            size: 5,
                            editable: false,
                            queryMode: 'local',
                            store: [
                                [
                                    'MB',
                                    'MB'
                                ],
                                [
                                    'GB',
                                    'GB'
                                ],
                                [
                                    'TB',
                                    'TB'
                                ]
                            ],
                            valueField: 'name'
                        },
                        {
                            xtype: 'numberfield',
                            id: 'device.vm.cpu',
                            fieldLabel: 'Processors',
                            name: 'cpu',
                            value: 1,
                            maxValue: 8,
                            minValue: 1
                        },
                        {
                            xtype: 'numberfield',
                            id: 'device.vm.cores',
                            padding: '0 0 0 5',
                            fieldLabel: 'Cores',
                            name: 'cores',
                            value: 1,
                            decimalPrecision: 0,
                            maxValue: 8,
                            minValue: 1
                        },
                        {
                            xtype: 'numberfield',
                            id: 'device.vm.hdd1',
                            fieldLabel: 'Hard Disk 1',
                            name: 'hdd1',
                            value: 32,
                            minValue: 0
                        },
                        {
                            xtype: 'combobox',
                            id: 'device.vm.hddmetric1',
                            padding: '0 0 0 5',
                            name: 'hddmetric1',
                            value: [
                                'GB',
                                'GB'
                            ],
                            size: 5,
                            editable: false,
                            queryMode: 'local',
                            store: [
                                [
                                    'MB',
                                    'MB'
                                ],
                                [
                                    'GB',
                                    'GB'
                                ],
                                [
                                    'TB',
                                    'TB'
                                ]
                            ],
                            valueField: 'name'
                        }
                    ]
                },
                {
                    xtype: 'splitbutton',
                    id: 'device.vm.addpartbtn',
                    text: 'Add Field',
                    menu: {
                        xtype: 'menu',
                        width: 120,
                        items: [
                            {
                                xtype: 'menuitem',
                                id: 'device.vm.addhddbtn',
                                text: 'Add Harddisk',
                                listeners: {
                                    click: {
                                        fn: me.onaddhddbtnClick,
                                        scope: me
                                    }
                                }
                            },
                            {
                                xtype: 'menuitem',
                                id: 'device.vm.addnetbtn',
                                text: 'Add Network',
                                listeners: {
                                    click: {
                                        fn: me.onaddnetbtnClick,
                                        scope: me
                                    }
                                }
                            }
                        ]
                    }
                },
                {
                    xtype: 'fieldset',
                    title: 'Description',
                    items: [
                        {
                            xtype: 'htmleditor',
                            anchor: '100%',
                            formBind: true,
                            height: 150,
                            id: 'device.vm.description',
                            name: 'description'
                        }
                    ]
                }
            ]
        });

        me.callParent(arguments);
    },

    onosSelect: function(combo, records, eOpts) {
        //var win = this.getDeviceCreateWindow();

        console.log("In onosSelect");
        console.log(records);

        /* var osverstore = Ext.create('NeoDoc.store.VersionStore');
        osverstore.storeid = 'OsVerStore-'+combo.getValue();
        */


        var versselect = this.down('#devicevmosversion'),
            osverstore = versselect.getStore();

        osverstore.getProxy().extraParams.whattoget='osversioninfo';
        osverstore.getProxy().extraParams.osid=combo.getValue();

        osverstore.reload();
        versselect.setValue(osverstore.getAt(0).data.name)

        // versselect.store = osverstore;

        versselect.setDisabled(false);



    },

    onaddhddbtnClick: function(item, e, eOpts) {
        console.log('in onaddhddbtnClick');
        var me = this,
            form = this.getForm(),
            parts = Ext.getCmp('device.vm.parts'),
            i = 2;

        var h = form.findField("hdd"+i)

        while (h) {
            console.log("Found hdd" + i);
            i++;
            h = form.findField("hdd"+i);
            //h.destroy();
        }

        console.log("Found "+(i-1)+" hdd fields");

        if (i<32) {

            var hddfield = new Ext.form.NumberField(
            {
                xtype: 'numberfield',
                id: 'device.vm.hdd'+i,
                fieldLabel: 'Hard Disk '+i,
                name: 'hdd'+i,
                value: 32,
                minValue: 0
            });
            var hddmetric = new Ext.form.ComboBox({
                xtype: 'combobox',
                id: 'device.vm.hddmetric'+i,
                padding: '0 0 0 5',
                name: 'hddmetric'+i,
                value: [
                'GB',
                'GB'
                ],
                size: 5,
                editable: false,
                queryMode: 'local',
                store: [
                [
                'MB',
                'MB'
                ],
                [
                'GB',
                'GB'
                ],
                [
                'TB',
                'TB'
                ]
                ],
                valueField: 'name'
            });

            parts.insert(hddfield)
            parts.insert(hddmetric)



        }





    },

    onaddnetbtnClick: function(item, e, eOpts) {

    }

});