/*
 * File: app/controller/Location.js
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

Ext.define('NeoDoc.controller.Location', {
    extend: 'Ext.app.Controller',

    stores: [
        'navTreeStore'
    ],

    refs: [
        {
            ref: 'newLocationWindow',
            selector: 'newlocationwindow'
        },
        {
            ref: 'locationTreeTab',
            selector: 'locationtreetab'
        },
        {
            ref: 'locationTreePanel',
            selector: 'locationtreepanel'
        },
        {
            ref: 'treeTabPanel',
            selector: 'treetabpanel'
        }
    ],

    onLocationNewBtn: function(button, e, eOpts) {
        console.log("In onLocationNewBtn");
        var win = Ext.create('NeoDoc.view.location.CreateWindow', {});
        win.show();

    },

    onCreateLocation: function(button, e, eOpts) {
        console.log('In onCreateLocation');
        var me = this,
            win = this.getNewLocationWindow(), 
            form = win.items.items[0].getForm();

        var nameField = form.findField('name');
        console.log('name:',nameField);
        if (form.isValid()) {    
            win.setLoading('Submitting...');
            form.submit({
                url: '/api/locations',
                headers: {'Accept':'application/vnd.neodocapi.v1' },
                method: 'POST',
                success: function(result, action) {
                    Ext.Msg.alert('Created location successfully!');
                    var store = Ext.StoreMgr.get('navTreeStore');
                    store.load();
                    win.setLoading(false);
                    win.destroy();
                    // TODO: Reload tree store
                },
                failure: function(result, action) {
                    Ext.Msg.alert('Failed to create location!\n\n'+result);
                    win.setLoading(false);
                }
            });
        }



    },

    onTreepanelSelect: function(rowmodel, record, index, eOpts) {
        var me = this;

        console.log("In TreePanelSelect");
        console.log('Record cls is '+record.get('cls'));

        switch (record.get('cls')) {
            case 'Network':
            console.log('Adding network tab');
            me.application.fireEvent('newnetworktab', record.data);
            break;
            case 'Device':
            console.log('Adding device tab');
            me.application.fireEvent('newdevicetab', record.data);
            break;
            case 'DeviceFolder':
            console.log('Adding devicefolder tab');
            me.application.fireEvent('newdevicefoldertab', record.data);
            break;

        }


    },

    onTreepanelItemContextMenu: function(dataview, record, item, index, e, eOpts) {
        var x,y,show=false;
        var menu1;

        console.log("IN context menu");
        console.log("Clicked Item is of class: "+record.get('cls'));



        switch (record.get('cls')) {
            case 'Location':
            //     menu1=this.getLocationMenu();

            show = true;
            menu1= new Ext.menu.Menu({
                itemid: 'locationMenu',
                items: [
                {
                    xtype: 'menuitem',
                    text: 'New Network...',
                    itemid: 'locationMenuNewNetwork',
                    handler: function() {
                        var win = Ext.create('NeoDoc.view.network.CreateWindow', {});
                        var pid = win.down('#networkParentId');
                        pid.setValue(record.get('id'));
                        win.show();
                    }
                },
                {
                    xtype: 'menuitem',
                    text: 'New Document...',
                    action: 'onCreateDocument',
                    itemid: 'documentMenuNewNetwork',
                    disabled: true
                }            
                ]
            });
        }
        if (show) {
            x = e.browserEvent.clientX;
            y = e.browserEvent.clientY;
            console.log("X="+x);
            console.log("Y="+y);
            //menu1.showAt([x,y]);
            menu1.showAt(e.getXY());
            e.stopEvent();
        }

    },

    onMainMenuLocation: function(item, e, eOpts) {
        console.log('In onMainMenuLocation');


        var view = Ext.getCmp('mainWorkContainer').down('#locationtabpanel');

        if (view == null) {



            var cont = Ext.getCmp('mainviewport').down('#mainWorkContainer');

            console.log(cont);

            cont.add({
                xtype: 'locationtreetab',
                region: 'west',
                id: 'locationtreetab',
                width: 167,
                layout: {
                    type: 'fit'
                }
            });

            cont.add({
                xtype: 'maintabpanel',
                itemid: 'locationtabpanel',
                id: 'locationtabpanel',
                region: 'center'
            });


        } else {

            var cont = Ext.getCmp('mainviewport').down('#mainWorkContainer');

            console.log(cont);

            cont.removeAll();

        }


    },

    onLoggedin: function(userrecord) {
        console.log("In location onLoggedin");

        var treepanel = Ext.create('NeoDoc.view.location.Treetab', {}),
            loctreetab = Ext.create('NeoDoc.view.MainTabPanel', {});
        /*
        var cont = Ext.getCmp('mainviewport').down('#mainWorkContainer');

        console.log(cont);

        cont.add({
        xtype: 'locationtreetab',
        region: 'west',
        width: 167,
        layout: {
        type: 'fit'
        }
        });

        cont.add({
        xtype: 'maintabpanel',
        itemid: 'locationtabpanel',
        id: 'locationtabpanel',
        region: 'center'
        });


        */
    },

    init: function(application) {
        this.control({
            "locationtreetab button[action=newlocation]": {
                click: this.onLocationNewBtn
            },
            "newlocationwindow button[action=locationcreate]": {
                click: this.onCreateLocation
            },
            "#locationTreePanel": {
                select: this.onTreepanelSelect,
                itemcontextmenu: this.onTreepanelItemContextMenu
            },
            "#mainMenu": {
                click: this.onMainMenuLocation
            }
        });

        application.on({
            loggedin: {
                fn: this.onLoggedin,
                scope: this
            }
        });
    }

});
