/*
 * File: app/view/device/GeneralPanel.js
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

Ext.define('NeoDoc.view.device.GeneralPanel', {
    extend: 'Ext.panel.Panel',

    height: 199,
    width: 629,
    resizable: true,
    bodyPadding: 10,

    initComponent: function() {
        var me = this;

        Ext.applyIf(me, {
            tpl: [
                '<div class="post-data">',
                '    <span class="post-date">Last updated by {updated_by} at {updated_at}</span>',
                '    <h3 class="post-title"><b>Device Name:</b> {name}</h3><br>',
                '    <b>Type: </b> {devicetype}<br>',
                '    <b>Serial number:</b> {serialnr}<br>',
                '	<b>Model:</b> {model}<br>',
                '    <b>Label:</b> {label}<br>',
                '</div>',
                '<p>',
                '    <div class="post-body"><b>Description:</b><p>{description}</div>'
            ]
        });

        me.callParent(arguments);
    }

});