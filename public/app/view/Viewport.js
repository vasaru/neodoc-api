Ext.define('NeoDoc.view.Viewport', {
    extend: 'Ext.container.Viewport',
    requires:[
        'Ext.layout.container.Border',
       // 'NeoDoc.view.layout.South',
        'NeoDoc.view.layout.West',
        'NeoDoc.view.layout.Center'
    ],
    layout: {
        type: 'border'
    },
    items: [
        // { xtype: 'layout.south' },
        { xtype: 'layout.west' },
        { xtype: 'layout.center' }
    ]
});