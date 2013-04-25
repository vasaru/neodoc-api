/*
 * File: app/controller/Location.js
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

Ext.define('NeoDoc.controller.Location', {
    extend: 'Ext.app.Controller',

    refs: [
        {
            ref: 'newLocationWindow',
            selector: 'newlocationwindow'
        },
        {
            ref: 'locationTreeTab',
            selector: 'locationtreetab'
        }
    ],

    onLocationNewBtn: function(button, e, eOpts) {
        console.log("In onLocationNewBtn");
        var win = Ext.create('NeoDoc.view.NewLocationWindow', {});
        win.show();

    },

    onCreateLocation: function(button, e, eOpts) {
        console.log('In onCreateLocation');
        var me = this,
            win = this.getNewLocationWindow(), 
            form = win.items.items[0].getForm();

        var nameField = form.findField('name');
        console.log('email:',emailField);



    },

    init: function(application) {
        this.control({
            "locationtreetab button[action=newlocation]": {
                click: this.onLocationNewBtn
            },
            "newlocationwindow button[action=locationcreate]": {
                click: this.onCreateLocation
            }
        });
    }

});