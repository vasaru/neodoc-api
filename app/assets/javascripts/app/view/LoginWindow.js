/*
 * File: app/view/LoginWindow.js
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

Ext.define('NeoDoc.view.LoginWindow', {
    extend: 'Ext.window.Window',
    alias: 'widget.loginwindow',

    height: 195,
    width: 400,
    layout: {
        type: 'fit'
    },
    closable: false,
    title: 'Login',
    modal: true,

    initComponent: function() {
        var me = this;

        Ext.applyIf(me, {
            items: [
                {
                    xtype: 'form',
                    bodyPadding: 30,
                    frameHeader: false,
                    paramsAsHash: true,
                    waitTitle: 'Logging in...',
                    items: [
                        {
                            xtype: 'textfield',
                            anchor: '100%',
                            fieldLabel: 'Email',
                            name: 'email',
                            inputType: 'email',
                            allowBlank: false,
                            allowOnlyWhitespace: false
                        },
                        {
                            xtype: 'textfield',
                            anchor: '100%',
                            fieldLabel: 'Password',
                            name: 'password',
                            inputType: 'password',
                            allowBlank: false,
                            allowOnlyWhitespace: false
                        }
                    ],
                    dockedItems: [
                        {
                            xtype: 'toolbar',
                            dock: 'bottom',
                            formBind: false,
                            ui: 'footer',
                            items: [
                                {
                                    xtype: 'tbspacer',
                                    flex: 1
                                },
                                {
                                    xtype: 'button',
                                    action: 'login',
                                    formBind: true,
                                    text: 'Login',
                                    type: 'submit'
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