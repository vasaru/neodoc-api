/*
 * File: app/view/MyViewport.js
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

Ext.define('NeoDoc.view.MyViewport', {
    extend: 'Ext.container.Viewport',

    requires: [
        'NeoDoc.view.TreeTabPanel',
        'NeoDoc.view.MainTabPanel'
    ],

    id: 'mainviewport',
    layout: {
        type: 'border'
    },

    initComponent: function() {
        var me = this;

        Ext.applyIf(me, {
            items: [
                {
                    xtype: 'panel',
                    region: 'north',
                    height: 50,
                    bodyPadding: 20,
                    bodyStyle: {
                        'background-image': 'url(images/background2.png) !important'
                    },
                    header: false,
                    title: 'NeoDoc'
                },
                {
                    xtype: 'toolbar',
                    region: 'south',
                    height: 37,
                    items: [
                        {
                            xtype: 'tbfill'
                        },
                        {
                            xtype: 'tbseparator'
                        },
                        {
                            xtype: 'tbtext',
                            itemId: 'loggedintext',
                            text: 'My Text'
                        },
                        {
                            xtype: 'tbspacer',
                            width: 50
                        },
                        {
                            xtype: 'tbseparator'
                        },
                        {
                            xtype: 'button',
                            action: 'logout',
                            iconCls: 'logout_user',
                            text: 'Logout'
                        }
                    ]
                },
                {
                    xtype: 'treetabpanel',
                    region: 'west'
                },
                {
                    xtype: 'maintabpanel',
                    hidden: false,
                    region: 'center'
                }
            ]
        });

        me.callParent(arguments);
    }

});