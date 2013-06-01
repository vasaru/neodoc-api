/*
 * File: app/controller/Device.js
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

Ext.define('NeoDoc.controller.Device', {
    extend: 'Ext.app.Controller',

    refs: [
        {
            ref: 'deviceCreateWindow',
            selector: 'devicecreatewindow'
        },
        {
            ref: 'MainTabPanel',
            selector: 'maintabpanel'
        },
        {
            ref: 'deviceMainTab',
            selector: 'devicemaintab'
        }
    ],

    onCreateDevice: function(button, e, eOpts) {
        console.log("In onCreateDevice");
        var me = this,
            win = this.getDeviceCreateWindow(),
            form1 = win.down('#newDevice-1').getForm(),
            form2 = win.down('#newDevice-2').getForm();
        if (form1.isValid() && form2.isValid()) {    
            win.setLoading('Submitting...');
            Ext.Ajax.request({
                url: '/api/devices',
                params: Ext.encode({
                    formData1: form1.getValues(),
                    formData2: form2.getValues()
                }),
                headers: {'Accept':'application/vnd.neodocapi.v1' },
                method: 'POST',
                success: function(result, action) {
                    Ext.Msg.alert('Created device successfully!');
                    win.setLoading(false);
                    win.destroy();
                    var grid = Ext.getCmp(JSON.parse(action.params).formData1.callerid);
                    grid.setLoading(true);
                    grid.getStore().reload();
                    grid.setLoading(false);
                },
                failure: function(result, action) {
                    Ext.Msg.alert('Failed to create device!\n\n'+result);
                    win.setLoading(false);
                }
            });
        }
    },

    onNewdevicetab: function(record) {
        console.log('in onNewdevicetab');
        console.log(record);

        var me = this,
            maintab = me.getMainTabPanel();




    },

    onNewdevicefoldertab: function(record) {
        var me = this,
            maintab = me.getMainTabPanel();

        console.log('in onNewdevicefoldertab');
        console.log(record);

        var devstore = Ext.create('NeoDoc.store.DeviceFolderStore');
        devstore.storeid = 'DeviceFolderStore-'+record.parentId;
        devstore.defaultRootId = record.parentId;


        console.log('panelId=DevFolderTab-'+record.parentId);

        var tab = maintab.getChildByElement('DevFolderTab-'+record.parentId);

        if(!tab) {
            var devfoldertab = Ext.create('NeoDoc.view.network.MainTabPanel', {
                title: 'Devices - '+record.text,
                id: 'DevFolderTab-'+record.parentId,
                itemId: 'DevFolderTab-'+record.parentId,
                cls: 'DeviceFolder',
                closable: true
            });


            var devfoldergrid = Ext.create('NeoDoc.view.device.FolderGrid', {
                title: 'Device Folder Grid',
                id: 'DevFolderTab-Grid'+record.parentId,
                itemId: 'DevFolderTab-Grid'+record.parentId,
                cls: 'DeviceFolder',
                store: devstore,
                closable: false
            });


            devstore.getProxy().extraParams.whattoget='getlocationdevices';
            devstore.getProxy().extraParams.locationid=record.parentId;


            //        ipgridpage.bindStore(ipstore);
            //        ipgrid.reconfigure(ipstore);

            devstore.loadPage(1);

            devfoldertab.add(devfoldergrid);

            maintab.add(devfoldertab);

            maintab.setActiveTab(devfoldertab);

        } else {
            maintab.setActiveTab(tab);
        }

    },

    init: function(application) {
        this.control({
            "devicecreatewindow button[action=newdevice]": {
                click: this.onCreateDevice
            }
        });

        application.on({
            newdevicetab: {
                fn: this.onNewdevicetab,
                scope: this
            },
            newdevicefoldertab: {
                fn: this.onNewdevicefoldertab,
                scope: this
            }
        });
    }

});
