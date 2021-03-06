/*
 * File: app/view/location/Treetab.js
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

Ext.define('NeoDoc.view.location.Treetab', {
    extend: 'Ext.panel.Panel',
    alias: 'widget.locationtreetab',

    width: 114,
    resizable: true,
    resizeHandles: 'e',
    layout: {
        type: 'fit'
    },
    collapseDirection: 'left',
    collapsible: true,
    title: 'Locations',

    initComponent: function() {
        var me = this;

        Ext.applyIf(me, {
            items: [
                {
                    xtype: 'treepanel',
                    cls: 'location-list',
                    id: 'locationTreePanel',
                    itemId: 'locationTreePanel',
                    width: 150,
                    collapsed: false,
                    header: false,
                    store: 'navTreeStore',
                    rootVisible: false,
                    viewConfig: {

                    }
                }
            ],
            dockedItems: [
                {
                    xtype: 'toolbar',
                    dock: 'bottom',
                    items: [
                        {
                            xtype: 'button',
                            action: 'newlocation',
                            id: 'newLocationBtn',
                            itemId: 'newLocationBtn',
                            iconCls: 'location-icon',
                            text: 'New Location'
                        }
                    ]
                }
            ]
        });

        me.callParent(arguments);
    }

});