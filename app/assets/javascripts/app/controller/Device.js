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
                    var grid = Ext.getCmp(JSON.parse(action.params).formData1.callerid);
                    grid.setLoading(true);
                    grid.getStore().reload();
                    // grid.getStore().reload();
                    // store.load();
                    win.setLoading(false);
                    grid.setLoading(false);
                    win.destroy();
                    // TODO: Reload tree store
                },
                failure: function(result, action) {
                    Ext.Msg.alert('Failed to create device!\n\n'+result);
                    win.setLoading(false);
                }
            });
        }
    },

    init: function(application) {
        this.control({
            "devicecreatewindow button[action=newdevice]": {
                click: this.onCreateDevice
            }
        });
    }

});
